-- исправляем account_in_sum на основе account_out_sum предыдущего дня
update rd.account_balance as curr
set account_in_sum = prev.account_out_sum
from rd.account_balance as prev
where prev.account_rk = curr.account_rk
  and prev.effective_date = curr.effective_date - interval '1 day'
  and curr.account_in_sum != prev.account_out_sum;

-- исправляем account_out_sum на основе account_in_sum следующего дня
update rd.account_balance as curr
set account_out_sum = next.account_in_sum
from rd.account_balance as next
where next.account_rk = curr.account_rk
  and next.effective_date = curr.effective_date + interval '1 day'
  and curr.account_out_sum != next.account_in_sum;