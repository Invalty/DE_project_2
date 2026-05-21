CREATE OR REPLACE PROCEDURE refresh_loan_holiday_info()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Очищаем витрину
    TRUNCATE TABLE dm.loan_holiday_info;
    
    -- Вставляем данные по прототипу
    INSERT INTO dm.loan_holiday_info (
        deal_rk,
        effective_from_date,
        effective_to_date,
        agreement_rk,
        client_rk,
        department_rk,
        product_rk,
        product_name,
        deal_type_cd,
        deal_start_date,
        deal_name,
        deal_number,
        deal_sum,
        loan_holiday_type_cd,
        loan_holiday_start_date,
        loan_holiday_finish_date,
        loan_holiday_fact_finish_date,
        loan_holiday_finish_flg,
        loan_holiday_last_possible_date
    )
    WITH deal AS (
        SELECT 
            deal_rk,
            deal_num,
            deal_name,
            deal_sum,
            client_rk,
            agreement_rk,
            deal_start_date,
            department_rk,
            product_rk,
            deal_type_cd,
            effective_from_date,
            effective_to_date
        FROM rd.deal_info
    ),
    loan_holiday AS (
        SELECT 
            deal_rk,
            loan_holiday_type_cd,
            loan_holiday_start_date,
            loan_holiday_finish_date,
            loan_holiday_fact_finish_date,
            loan_holiday_finish_flg,
            loan_holiday_last_possible_date,
            effective_from_date,
            effective_to_date
        FROM rd.loan_holiday
    ),
    product AS (
        SELECT 
            product_rk,
            product_name,
            effective_from_date,
            effective_to_date
        FROM rd.product
    ),
    holiday_info AS (
        SELECT 
            d.deal_rk,
            lh.effective_from_date,
            lh.effective_to_date,
            d.deal_num AS deal_number,
            lh.loan_holiday_type_cd,
            lh.loan_holiday_start_date,
            lh.loan_holiday_finish_date,
            lh.loan_holiday_fact_finish_date,
            lh.loan_holiday_finish_flg,
            lh.loan_holiday_last_possible_date,
            d.deal_name,
            d.deal_sum,
            d.client_rk,
            d.agreement_rk,
            d.deal_start_date,
            d.department_rk,
            d.product_rk,
            p.product_name,
            d.deal_type_cd
        FROM deal d
        LEFT JOIN loan_holiday lh ON d.deal_rk = lh.deal_rk
                                  AND d.effective_from_date = lh.effective_from_date
        LEFT JOIN product p ON p.product_rk = d.product_rk
                            AND p.effective_from_date = d.effective_from_date
    )
    SELECT 
        deal_rk,
        effective_from_date,
        effective_to_date,
        agreement_rk,
        client_rk,
        department_rk,
        product_rk,
        product_name,
        deal_type_cd,
        deal_start_date,
        deal_name,
        deal_number,
        deal_sum,
        loan_holiday_type_cd,
        loan_holiday_start_date,
        loan_holiday_finish_date,
        loan_holiday_fact_finish_date,
        loan_holiday_finish_flg,
        loan_holiday_last_possible_date
    FROM holiday_info;
END;
$$;

call refresh_loan_holiday_info();


select 'loan_holiday_info' as table_name, count(*) as cnt from dm.loan_holiday_info
union all
select 'deal_info', count(*) from rd.deal_info
union all
select 'loan_holiday', count(*) from rd.loan_holiday
union all
select 'product', count(*) from rd.product;

