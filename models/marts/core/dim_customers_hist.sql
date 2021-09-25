{{ config(
    materialized = 'incremental',
    unique_key = 'customer_id'
    ) }}
with dim_customer_hist as (
    select * from {{ ref('dim_customers') }}
      {% if is_incremental() %}
      where MOST_RECENT_ORDER_DATE >= (select max(MOST_RECENT_ORDER_DATE) from {{ this }})
      and MOST_RECENT_ORDER_DATE is not null
      {% endif %}
)
select * from dim_customer_hist