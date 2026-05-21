-- Запрос показывает проблемные строки и корректные значения для account_in_sum
with account_balance_with_next as (
    select ab.account_rk,
        ab.account_out_sum,
        lead(ab.account_in_sum) over (
            partition by ab.account_rk 
            order by ab.effective_date
        ) as next_day_account_in_sum
    from rd.account_balance ab
),
corrected_balance as (
    select 
        account_rk,
        account_out_sum as original_out_sum,
        case 
            when next_day_account_in_sum is not null 
                 and account_out_sum != next_day_account_in_sum 
            then next_day_account_in_sum
            else account_out_sum
        end as corrected_out_sum
    from account_balance_with_next
)
select account_rk, original_out_sum, corrected_out_sum,
    case 
        when original_out_sum != corrected_out_sum then 'Не совпадает('
        else 'Совпадает)'
    end as status
from corrected_balance
order by account_rk;


-- запрос показывает проблемные строки и корректные значения для account_out_sum
with account_balance_with_prev as (
    select ab.account_rk,ab.account_in_sum,
        lag(ab.account_out_sum) over (
            partition by ab.account_rk 
            order by ab.effective_date
        ) as prev_day_account_out_sum
    from rd.account_balance ab
),
corrected_balance as (
    select account_rk,
        account_in_sum as original_in_sum,
        prev_day_account_out_sum,
        case 
            when prev_day_account_out_sum is not null 
                 and account_in_sum != prev_day_account_out_sum 
            then prev_day_account_out_sum
            else account_in_sum
        end as corrected_in_sum
    from account_balance_with_prev
)
select 
    account_rk, original_in_sum, corrected_in_sum,
    case 
        when original_in_sum != corrected_in_sum then 'Не совпадает('
        else 'Совпадает)'
    end as status
from corrected_balance
order by account_rk;