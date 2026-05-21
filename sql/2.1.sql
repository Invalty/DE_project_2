select client_rk, effective_from_date, count(*)
from dm.client
group by client_rk, effective_from_date
having count(*) > 1;

delete from dm.client c1
where exists(
	select 1 from dm.client c2
	where c1.client_rk = c2.client_rk and
	c1.effective_from_date = c2.effective_from_date and
	c1.ctid > c2.ctid
)