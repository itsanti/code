show create table ads_data;
show create table ads_clients_data;

describe ads_data;

SELECT
    partition,
    name,
    active
FROM system.parts
WHERE table = 'ads_data';

select
	uniq(target_audience_count)    
from ads_data ad 
where `date` = '2019-04-01';

-- ['ios','web','android']
SELECT groupUniqArray(platform) from ads_data

-- ['android','web','android','web','android','android','android','ios','web','android']
SELECT groupArray(10)(platform) from ads_data  

SELECT sort(groupUniqArray(platform)) from ads_data


-- https://stepik.org/lesson/416851/step/2?unit=406358
select
	countIf(platform = 'android') as Android,
	countIf(platform = 'ios') as iOS
from
	ads_data
where 
	event = 'view';

select sumIf(ad_cost, platform = 'android')
from ads_data

-- https://stepik.org/lesson/416851/step/3?unit=406358
select uniqExact(platform)
from ads_data

-- https://stepik.org/lesson/416851/step/4?unit=406358
with (select uniqExact(ad_id) from ads_data) as sum_ads
select platforms, uniqExact(ad_id) as ads, sum_ads, ads / sum_ads * 100 as perc_ads
from (select ad_id, arraySort(groupUniqArray(platform)) as platforms
      from ads_data
      where event = 'view'
      group by ad_id
	  )
group by platforms
order by perc_ads desc

-- https://stepik.org/lesson/416851/step/7?unit=406358
with (select uniqExact(client_union_id) from ads_clients_data) as dump_clients
select
	uniqExact(client_union_id) as bad_clients, -- =)	
	dump_clients,	
	round(bad_clients  * 100 / dump_clients) as perc,
	min(create_date) as oldest_clients
from ads_clients_data
where
	client_union_id global not in (select distinct client_union_id from ads_data);
	
-- https://stepik.org/lesson/416851/step/8?unit=406358
with (select groupArray(dateDiff('day', create_date, first_ads))
	    from ads_clients_data
	 	     inner join
	 	     (select client_union_id, min(date) as first_ads
				from ads_data
			group by client_union_id)
	         using (client_union_id)
      ) as delta 
select round(avgArray(delta)) as avg, minArray(delta) as min, maxArray(delta) as max;


select round(avg(delta)) as avg, min(delta) as min, max(delta) as max
from (select dateDiff('day', create_date, first_ads) as delta
	    from ads_clients_data
	 	     inner join
	 	     (select client_union_id, min(date) as first_ads
				from ads_data
			group by client_union_id)
	         using (client_union_id));

