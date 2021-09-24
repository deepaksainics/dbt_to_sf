{% snapshot orders_hist %}
  {{
      config(
        target_database='raw',
        target_schema='dbt_dsaini',
        unique_key='order_id',
        strategy='check',
        check_cols=['status'],
        pre_hook="Delete from {{this}} where order_id in ({{prehook_hard_del_macro(source('dbt_dsaini','stg_orders'),this,'order_id')}})"
        )
}}

  with order_h as (
      select ORDER_ID,CUSTOMER_ID,ORDER_DATE,STATUS,
      current_date() as created_at,current_date() as updated_at 
      from {{source('dbt_dsaini','stg_orders')}}
  )

  select * from order_h

{% endsnapshot %}