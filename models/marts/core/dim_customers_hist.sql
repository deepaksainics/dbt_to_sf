{{ config(
    materialized = 'incremental',
    unique_key = 'customer_id',
    pre_hook="delete from {{this}} where customer_id in (select customer_id from {{this}} minus select customer_id from {{source('dbt_dsaini', 'dim_customers')}})"

) }}
with dim_customer_hist as (
    select * from {{ source('dbt_dsaini', 'dim_customers') }}
      {% if is_incremental() %}
      where MOST_RECENT_ORDER_DATE >= (select max(MOST_RECENT_ORDER_DATE) from {{ this }})
      and MOST_RECENT_ORDER_DATE is not null
      {% endif %}
)
select * from dim_customer_hist