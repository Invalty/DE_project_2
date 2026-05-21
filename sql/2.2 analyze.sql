-- количество записей в витрине и источниках
select 'loan_holiday_info' as table_name, count(*) as row_count from dm.loan_holiday_info
union all
select 'deal_info', count(*) from rd.deal_info
union all
select 'loan_holiday', count(*) from rd.loan_holiday
union all
select 'product', count(*) from rd.product;

-- поиск дублей по составному ключу
select deal_rk, effective_from_date, count(*) as duplicate_count
from dm.loan_holiday_info
group by deal_rk, effective_from_date
having count(*) > 1
order by duplicate_count desc;

-- проверка уникальности effective_from_date
select distinct effective_from_date 
from dm.loan_holiday_info 
order by effective_from_date;

select distinct effective_from_date 
from rd.deal_info 
order by effective_from_date;

select distinct effective_from_date 
from rd.loan_holiday 
order by effective_from_date;

select distinct effective_from_date 
from rd.product 
order by effective_from_date;