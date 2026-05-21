create or replace procedure dm.refresh_account_balance_turnover()
language plpgsql
as $$
begin
    truncate table dm.account_balance_turnover;
    
    insert into dm.account_balance_turnover (
        account_rk,
        currency_name,
        department_rk,
        effective_date,
        account_in_sum,
        account_out_sum
    )
    select 
        a.account_rk,
        coalesce(dc.currency_name, '-1'::text) as currency_name,
        a.department_rk,
        ab.effective_date,
        ab.account_in_sum,
        ab.account_out_sum
    from rd.account a
    left join rd.account_balance ab on a.account_rk = ab.account_rk
    left join dm.dict_currency dc on a.currency_cd = dc.currency_cd;
end;
$$;

call dm.refresh_account_balance_turnover();

-- количество записей в витрине
select count(*) from dm.account_balance_turnover;

-- первые 10 строк
select * from dm.account_balance_turnover limit 10;