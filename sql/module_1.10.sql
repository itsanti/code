-- https://stepik.org/lesson/416847/step/9?unit=406355
select sum(salary) from employee e 
where concat(name, ' ', surname) IN ('Rick Sanchez C-137', 'Morty Smith');

-- https://stepik.org/lesson/416847/step/10?unit=406355
select round(avg(salary)) from employee e 
where job_title = 'Data Science';

-- https://stepik.org/lesson/416847/step/11?unit=406355
select name from employee
where company_id = (
		select id from company c where name = 'GoGoogle'
	)
group by name
order by count(*) desc limit 1;

-- https://stepik.org/lesson/416847/step/12?unit=406355
select company.name, count(start_date)
from employee
	join company on company.id = employee.company_id 
where end_date IS NOT null
group by company.name;

-- https://stepik.org/lesson/416847/step/13?unit=406355
select job_title, count(*) as count
from employee
group by job_title
order by count desc limit 5;

-- https://stepik.org/lesson/416847/step/14?unit=406355
select o.country, count(e.job_title) as cc
from employee e 
	join office o on e.office_id = o.id
where e.job_title like '%DevOps%'
group by o.country
order by cc desc limit 1;

-- https://stepik.org/lesson/416847/step/15?unit=406355
select id, job_title, DATE_PART('day', end_date::timestamp - start_date::timestamp) as days
from employee e
where end_date is not null
order by days limit 1;

-- https://stepik.org/lesson/416847/step/16?unit=406355
select end_date, count(end_date) as count
from employee e 
where end_date is not null
group by end_date
order by count desc limit 1;
