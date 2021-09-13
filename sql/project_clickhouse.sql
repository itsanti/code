/**
 * 1. �������� ���������� �� ����. ������ ��������� ����� ���� ������� �� ����,
 * ����� �������, ����� ������, ����� ���������� ���������� � ���������� ��������.
 */

select
	date as `����`,
	count(event) as `���_�������`,
	countIf(event = 'view') as `������`,
	countIf(event = 'click') as `�����`,
	uniqExact(ad_id) as `����������`,
	uniqExact(campaign_union_id) as `��������`
from ads_data
group by date;

/**
	����      |���_�������|������|�����|����������|��������|
	----------|-----------|------|-----|----------|--------|
	2019-04-01|      22073| 21782|  291|       150|     149|
	2019-04-02|      47117| 46572|  545|       344|     336|
	2019-04-03|      59483| 59023|  460|       360|     352|
	2019-04-04|     275735|275092|  643|       407|     396|
	2019-04-05|     519707|427386|92321|       465|     442|
	2019-04-06|      75885| 60967|14918|       220|     212|
*/

/**
 * 2. �����������, ������ �������� ����� ������ 2019-04-05?
 * ����� ������� ����� ������? � ���� ���������� ��� ������ � ���������?
 */

-- ���������� ad_id=112583 ������� 302811 ����������. ������ ����� � android ���������
select ad_id, count(event), countIf(event = 'view'), countIf(event = 'click')
from ads_data
where `date` = toDate('2019-04-04')
group by ad_id
order by count(event) desc limit 5;

select platform, count(ad_id)
from ads_data
where ad_id = 112583
group by platform;

/* 
	ad_id |count(event)|countIf(equals(event, 'view'))|countIf(equals(event, 'click'))|
	------|------------|------------------------------|-------------------------------|
	107729|      154968|                        154872|                             96|
	107837|       43681|                         43658|                             23|
	 45008|       16534|                         16523|                             11|
	 22490|        7248|                          7240|                              8|
	 39191|        2824|                          2793|                             31| 
 */


/**
 * 3. ����� ��� 10 ���������� �� CTR �� ��� �����.
 * CTR � ��� ��������� ���� ������ ���������� � ����������.
 * ��������, ���� � ���������� ���� 100 ������� � 2 �����,�CTR = 0.02.
 * ����������� �� ������� � ��������� CTR ���������� � ����� ������?
 */

select
	ad_id,
	round(countIf(event='click') / countIf(event='view'), 2) as CTR
from ads_data
group by ad_id
-- �������� ���������� ��� ������� (���)
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
 *  � ��� �� ��������� �������� ����� ���� ������� �� �����������.
 * 
	avgCTR|medianCTR|
	------|---------|
	0.0158|   0.0029|
*/

/**
 * 4. ������, � ����� ����� ���� ���, ���������� �������� � �������, �� ��� �������!
 * ������� ����� ����������, ���� �� �����-�� ��������������?
 * ��� �������� ����������� �� ���� ����������?
 */

select count() as bug_count, groupArray(ad_id) as ad_ids
from (
	select ad_id from ads_data
	group by ad_id
	having countIf(event='view') = 0
);

/*
 * ��� ����. ���������� ����� 9
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
 *  �������� �� ���� ����������. �� ������� �� ���� ������, ��������� � ���������� �������.
 *  ������� ���� ������� � ������ ����� `ads_clients_data.create_date`
 * 
	platforms              |cost_type    |client                                                     |
	-----------------------|-------------|-----------------------------------------------------------|
	['ios','web','android']|['CPC','CPM']|[26105,120412,117351,36207,120793,120417,1630,14606,115808]|
	
	clients_create_date                                                                                      |
	---------------------------------------------------------------------------------------------------------|
	['2018-12-17','2018-11-23','2018-11-17','2019-02-17','2018-12-11','2018-12-19','2019-03-03','2018-09-06']|
	
	-- ������������� �� ���������� ��� ���� ���������� ��� �������
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
 * ��� ��� 2 ���
 * 
	bug_date                   |
	---------------------------|
	['2019-04-02','2019-04-01']|
 */

select groupUniqArray(ad_cost_type) as bug_date
from ads_data
where ad_id in (115825,26204,45418,120431,41500,120796,120536,117364,19223);

/**
 * 5. ���� �� �������� � CTR � ���������� � ����� � ���?
 * � ���� ��������� 95 ���������� CTR �� ���� ����������� �� 2019-04-04?
 */

select 'avgVideoCTR' as CTR_type, round(avg(videoCTR), 4) as avgCTR
from (
	select
		round(countIf(event = 'click') / countIf(event = 'view'), 4) as videoCTR
	from ads_data ad
	where has_video = 1
	group by ad_id
	HAVING countIf(event = 'view') > 0
)

UNION ALL

select 'avgCTR' as CTR_type, round(avg(videoCTR), 4) as avgCTR
from (
	select
		round(countIf(event = 'click') / countIf(event = 'view'), 4) as videoCTR
	from ads_data ad
	where has_video = 0
	group by ad_id
	HAVING countIf(event = 'view') > 0
);

/*
 * � ���������� � ����� ������� CTR ���� �� 0,5%
 * 
	CTR_type   |avgCTR|
	-----------|------|
	avgVideoCTR|0.0201|
	avgCTR     |0.0157|
 */

-- 95 ���������� CTR �� ���� ����������� �� 2019-04-04
-- �� ����� 8.2%
select round(quantile(0.95)(CTR) * 100, 1) as CTR95
from (
	select
		countIf(event = 'click') / countIf(event = 'view') as CTR
	from ads_data
	where `date` = toDate('2019-04-04')
	group by ad_id
);


/**
 * 6. ��� ����������� ������ ����� ���������� ��� ��������� �� ����.
 * � ����� ���� �� ���������� ������ �����? � ����� ������?
 * �� ��������� � �������� ������, ���� ��������� ���� �� CPC ����������,
 * � �� ��������� ������ �� ������ ����� CPM ����������,
 * ���� � CPM ���������� ���� - 200 ������, �� �� ���� ����� �� ������������ 200 / 1000.
 */

select
	-- � ����� ���� �� ���������� ������ �����? � ����� ������?
	arrayElement(arraySort((x, y) -> y, groupArray(date), groupArray(total)), 1) as min_value_date,
	arrayElement(groupArray(total), indexOf(groupArray(date), min_value_date)) as min_value,
	arrayElement(arraySort((x, y) -> y, groupArray(date), groupArray(total)), -1) as max_value_date,
	arrayElement(groupArray(total), indexOf(groupArray(date), max_value_date)) as max_value
from (
	select date, round(sum(sub_total), 2) as total
	from (
		-- sub_total ��� ������� ��� � ����������
		select
			date,
			ad_id,
			ad_cost_type, arrayElement(groupUniqArray(ad_cost), 1) as price,
			count() as cnt,
			if(ad_cost_type = 'CPM', price  * cnt / 1000, price * cnt) as sub_total
		from ads_data
		group by date, ad_id, ad_cost_type
		order by date
	) group by date
);

/* ��������� ������� � ����� ���������� �� ������� ��� � ����������
	date      |ad_id |ad_cost_type|price|cnt |total             |
	----------|------|------------|-----|----|------------------|
	2019-04-01| 38368|CPM         |194.8| 104|20.259200317382813|
	2019-04-01| 29047|CPM         |196.0|  37|             7.252|
	2019-04-01| 46895|CPM         |191.6|  92|17.627200561523438|
	2019-04-01|112125|CPM         |203.3|  33| 6.708900100708008|
	2019-04-01|114451|CPM         |191.0| 225|            42.975|
	2019-04-01|121893|CPM         |190.8|  70|13.356000213623046|
	
	��������� �� ����
	date      |total    |
	----------|---------|
	2019-04-01|275839.86|
	2019-04-02| 537996.7|
	2019-04-03|502448.74|
	2019-04-04|575803.67|
	2019-04-05|550933.41|
	2019-04-06|  72532.6|
	
	� ����� ���� �� ���������� ������ �����? � ����� ������?
	
	min_value_date|min_value|max_value_date|max_value|
	--------------|---------|--------------|---------|
	    2019-04-06|  72532.6|    2019-04-04|575803.67|
 */

select date, ad_id, count() from ads_data ad 
where date = toDate('2019-04-01')
group by date, ad_id;


/**
 * 7. ����� ��������� ����� ���������� ��� ���������� ��������� ����������?
 * ������� ��������� ������� ���������� �� ������ �� �������� (������� platform)?
 */

-- ������������ �� ������� �������� (��� ������ ����������?), ��� ��� �� �����.
-- �� ��������� ������ � �������� ������� ����
select arrayElement(plt, 1) as platform, count() as cnt
from (
	select ad_id, groupArray(platform) as plt
	from
	(
		-- ���������� � ����� ������� ��������
		select ad_id, min(time) as time
		from ads_data 
		group by ad_id
	) as ad1 left join ads_data ad2
		on ad1.ad_id = ad2.ad_id and ad1.time = ad2.time
	group by ad_id
	-- �� ��������� ��������� �������� ��� ������ ��������
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
 * android ����� ���������� �� ���������� ����������
 * 
	platform|show_prcnt|
	--------|----------|
	android |     50.03|
	ios     |     29.99|
	web     |     19.98|
 */


/**
 * 8. � ���� �� ����� ����������, �� ������� ������� ��������� ����, � ������ ����� �����?
 */

-- � ���������� �� ��������� ������� � �������.
select ad_id, event, time from ads_data ad 
where ad_id = 107729 and `time` = toDateTime('2019-04-04 03:00:54', 'Europe/Moscow');

select 
	ad_id,
	arraySort((x, y) -> y, groupArray(event), groupArray(time)) as events_array
from ads_data
where ad_id IN (
	-- ���������� � ������ �������� click
	select ad_id
	from (
		select ad_id, groupUniqArray(event) as event
		from (select ad_id, min(`time`) as first_event_time
		from ads_data ad 
		group by ad_id) as fe
			left join ads_data ad
				on fe.first_event_time = ad.time and ad.ad_id = fe.ad_id
		group by ad_id
	) where has(event, 'click') and length(event) = 1
)
group by ad_id
having  arrayElement(events_array, 1) = 'click'
	and arrayElement(events_array, 2) = 'view';
	


-- https://clickhouse.tech/docs/ru/sql-reference/functions/conditional-functions/
-- ������������ �� ��
select date, sum(CPM_money), sum (CPC_money), sum( CPM_money + CPC_money) as gain 
from( 
select date, event, ad_cost_type, ad_cost, 
 countIf(event='view' and ad_cost_type= 'CPM')* ad_cost/1000 as CPM_money, 
 countIf(event = 'click' and ad_cost_type= 'CPC')*ad_cost as CPC_money 
 
 from ads_data 
 
group by date, event, ad_cost_type, ad_cost) 
group by date 
order by gain desc