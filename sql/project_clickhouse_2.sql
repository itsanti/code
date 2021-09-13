/**
 * 1. Получить статистику по дням. Просто посчитать число всех событий по дням,
 * число показов, число кликов, число уникальных объявлений и уникальных кампаний.
 */

select
	date as `дата`,
	count(event) as `все_события`,
	countIf(event = 'view') as `показы`,
	countIf(event = 'click') as `клики`,
	uniqExact(ad_id) as `объявления`,
	uniqExact(campaign_union_id) as `кампании`
from ads_data
group by date;

/**
	дата      |все_события|показы|клики|объявления|кампании|
	----------|-----------|------|-----|----------|--------|
	2019-04-01|      22073| 21782|  291|       150|     149|
	2019-04-02|      47117| 46572|  545|       344|     336|
	2019-04-03|      59483| 59023|  460|       360|     352|
	2019-04-04|     275735|275092|  643|       407|     396|
	2019-04-05|     519707|427386|92321|       465|     442|
	2019-04-06|      75885| 60967|14918|       220|     212|
*/

/**
 * 2. Разобраться, почему случился такой скачок 2019-04-05?
 * Каких событий стало больше? У всех объявлений или только у некоторых?
 */

select date, platform, countIf(event = 'view') as view, countIf(event = 'click') as click,
	round(click / view, 2) as CTR
from ads_data
group by date, platform
order by date, platform;
/*
    date      |platform|view  |click|CTR |
	2019-04-03|web     | 11906|   83|0.01|
	2019-04-04|android |137616|  323| 0.0|
	2019-04-04|ios     | 82587|  182| 0.0|
	2019-04-04|web     | 54889|  138| 0.0|
	2019-04-05|android |214103|46279|0.22|
	2019-04-05|ios     |128093|27698|0.22|
	2019-04-05|web     | 85190|18344|0.22|
	2019-04-06|android | 30469| 7394|0.24|
	2019-04-06|ios     | 18208| 4570|0.25|
	2019-04-06|web     | 12290| 2954|0.24|
 */

select date, floor(quantile(0.995)(cnt)) as q995
from (
	select date, ad_id, count(event) as cnt
	from ads_data
	group by date, ad_id
)
group by date;

/* - получается что больше 17000 событий уже что-то необычное
 * используем это для проверки
	date      |q995   |
	----------|-------|
	2019-04-01| 1233.0|
	2019-04-02| 2692.0|
	2019-04-03| 4667.0|
	2019-04-04|16255.0|
	2019-04-05|16913.0|
	2019-04-06| 3107.0|
 */

select date, ad_id,
	count(event) as cnt,
	countIf(event = 'view') as cnt_view,
	countIf(event = 'click') as cnt_click
from ads_data
group by date, ad_id
having count(event) > 17000
order by cnt desc;

/*
	date      |ad_id |cnt   |cnt_view|cnt_click|
	----------|------|------|--------|---------|
	2019-04-05|112583|393828|  302811|    91017|
	2019-04-04|107729|154968|  154872|       96|
	2019-04-06|112583| 63741|   48991|    14750|
	2019-04-04|107837| 43681|   43658|       23|
	2019-04-05|107729| 29745|   29724|       21|
	2019-04-05| 28142| 20903|   20872|       31|
 */

-- объявление ad_id=112583 собрало 302811 просмотров.
select ad_id, count(event), countIf(event = 'view'), countIf(event = 'click')
from ads_data
where `date` = toDate('2019-04-05')
group by ad_id
order by count(event) desc limit 5;

-- всплеск событий был у нескольких объявлений с 4-го по 6-ое число.

/**
 * 3. Найти топ 10 объявлений по CTR за все время.
 * CTR — это отношение всех кликов объявлений к просмотрам.
 * Например, если у объявления было 100 показов и 2 клика, CTR = 0.02.
 * Различается ли средний и медианный CTR объявлений в наших данных?
 */

select
	ad_id,
	round(countIf(event='click') / countIf(event='view'), 2) as CTR
from ads_data
group by ad_id
-- исключим объявления без показов (баг)
having countIf(event='view') > 0
order by CTR desc limit 10;

/*
	ad_id |CTR |
	------|----|
	117164|0.32|
	112583| 0.3|
	 42507|0.27|
	 98569|0.19|
	 46639|0.17|
	 23599|0.17|
	 19912|0.16|
	110414|0.16|
	 45969|0.15|
	 20662|0.15|
*/

select
	round(avg(CTR), 4) as avgCTR,
	round(median(CTR), 4) as medianCTR
from (
	select
		countIf(event='click') / countIf(event='view') as CTR
	from ads_data
	group by ad_id
	having countIf(event='view') > 0
);

/*
 *  у нас на рекламной площадке очень мало кликают по объявлениям.
 * 
	avgCTR|medianCTR|
	------|---------|
	0.0158|   0.0029|
*/

/**
 * 4. Похоже, в наших логах есть баг, объявления приходят с кликами, но без показов!
 * Сколько таких объявлений, есть ли какие-то закономерности?
 * Эта проблема наблюдается на всех платформах?
 */

select count() as bug_count, groupArray(ad_id) as ad_ids
from (
	select ad_id from ads_data
	group by ad_id
	having countIf(event='view') = 0
);

/*
 * баг есть. объявлений всего 9
 * 
	bug_count|ad_ids                                                      |
	---------|------------------------------------------------------------|
	        9|[115825,26204,45418,120431,41500,120796,120536,117364,19223]|
*/

select
	groupUniqArray(platform) as platforms,
	groupUniqArray(ad_cost_type) as cost_type,
	groupUniqArray(client_union_id) as client
from ads_data
where ad_id in (115825,26204,45418,120431,41500,120796,120536,117364,19223);

select groupUniqArray(create_date) as clients_create_date
from ads_clients_data 
where client_union_id in (26105,120412,117351,36207,120793,120417,1630,14606,115808);

select ad_id, platform, count()
from ads_data
where ad_id in (120431, 41500)
group by ad_id, platform
order by ad_id, platform;


/*
 *  проблема на всех платформах. не зависит от типа оплаты, стоимости и рекламного клиента.
 *  клиенты были созданы в разное время `ads_clients_data.create_date`
 * 
	platforms              |cost_type    |client                                                     |
	-----------------------|-------------|-----------------------------------------------------------|
	['ios','web','android']|['CPC','CPM']|[26105,120412,117351,36207,120793,120417,1630,14606,115808]|
	
	clients_create_date                                                                                      |
	---------------------------------------------------------------------------------------------------------|
	['2018-12-17','2018-11-23','2018-11-17','2019-02-17','2018-12-11','2018-12-19','2019-03-03','2018-09-06']|
	
	-- распределение по платформам для двух объявлений без показов
	ad_id |platform|count()|
	------|--------|-------|
	 41500|android |      8|
	 41500|ios     |      8|
	 41500|web     |      4|
	120431|android |     21|
	120431|ios     |      9|
	120431|web     |      5|
*/

select * FROM ads_data ad where ad_id = 120431;

select groupUniqArray(date) as bug_date
from ads_data
where ad_id in (115825,26204,45418,120431,41500,120796,120536,117364,19223);

/*
 * баг был 2 дня
 * 
	bug_date                   |
	---------------------------|
	['2019-04-02','2019-04-01']|
 */

-- не зависит от типа оплаты
select groupUniqArray(ad_cost_type) as bug_date
from ads_data
where ad_id in (115825,26204,45418,120431,41500,120796,120536,117364,19223);

-- У всех объявлений отсутствует видео
select has_video, groupUniqArray(ad_id) as bug_ad_id
from ads_data
where ad_id in (115825,26204,45418,120431,41500,120796,120536,117364,19223)
GROUP by has_video;

/**
 * 5. Есть ли различия в CTR у объявлений с видео и без?
 * А чему равняется 95 процентиль CTR по всем объявлениям за 2019-04-04?
 */

select has_video, round(avg(CTR), 4) as avgCTR
from (
	select
		has_video,
		round(countIf(event = 'click') / countIf(event = 'view'), 4) as CTR
	from ads_data ad
	group by has_video, ad_id
	HAVING countIf(event = 'view') > 0
)
group by has_video;


/*
 * у объявлений с видео средний CTR выше на 0,5%
 * 
	has_video|avgCTR|
	---------|------|
	        0|0.0157|
	        1|0.0202|
 */

-- 95 процентиль CTR по всем объявлениям за 2019-04-04
-- он равен 8.2%
select round(quantile(0.95)(CTR) * 100, 1) as CTR95
from (
	select
		countIf(event = 'click') / countIf(event = 'view') as CTR
	from ads_data
	where `date` = toDate('2019-04-04')
	group by ad_id
);


/**
 * 6. Для финансового отчета нужно рассчитать наш заработок по дням.
 * В какой день мы заработали больше всего? В какой меньше?
 * Мы списываем с клиентов деньги, если произошел клик по CPC объявлению,
 * и мы списываем деньги за каждый показ CPM объявления,
 * если у CPM объявления цена - 200 рублей, то за один показ мы зарабатываем 200 / 1000.
 */

select
	date,
	sum(multiIf(
		(ad_cost_type = 'CPC') AND (event = 'click'), ad_cost,
		(ad_cost_type = 'CPM') AND (event = 'view'), ad_cost / 1000, 0)
		) total
from ads_data
group by date
order by total desc;
-- Больше всего заработали 2019-04-05 - 96123.12, меньше всего 2019-04-01 - 6655.71

/**
 * 7. Какая платформа самая популярная для размещения рекламных объявлений?
 * Сколько процентов показов приходится на каждую из платформ (колонка platform)?
 */

-- результат близок к проценту показов ниже
select arrayElement(plt, 1) as platform, count() as cnt
from (
	select ad_id, groupArray(platform) as plt
	from
	(
		-- объявление и время первого действия
		select ad_id, min(time) as time
		from ads_data 
		group by ad_id
	) as ad1 left join ads_data ad2
		on ad1.ad_id = ad2.ad_id and ad1.time = ad2.time
	group by ad_id
	-- не учитываем несколько платформ при первом действии
	having length(plt) = 1
)
group by arrayElement(plt, 1)
order by cnt desc;

/*
	platform|cnt|
	--------|---|
	android |459|
	ios     |290|
	web     |192|
 */

with (select countIf(event='view') from ads_data) as total_view
select platform, round(countIf(platform, event='view') * 100 / total_view, 2) as show_prcnt
from ads_data
group by platform
order by show_prcnt desc;

/*
 * android самый популярный по просмотрам объявлений
 * 
	platform|show_prcnt|
	--------|----------|
	android |     50.03|
	ios     |     29.99|
	web     |     19.98|
 */


/**
 * 8. А есть ли такие объявления, по которым сначала произошел клик, а только потом показ?
 */

SELECT platform, ad_id,
       minIf(time, event = 'click' and time is not Null) AS min_click,
       minIf(time, event = 'view' and time is not Null) AS min_view
FROM ads_data
GROUP BY platform, ad_id
HAVING min_click != 0 and min_click  < min_view
ORDER BY platform;
