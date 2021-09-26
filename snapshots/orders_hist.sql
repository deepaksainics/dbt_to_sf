{% snapshot orders_hist %}
  {{
      config(
        target_schema=generate_schema_name('MART'),
        unique_key='id',
        strategy='check',
        check_cols=['status'],
      )
}}

select * from {{ source('jaffle_shop', 'orders') }}

{% endsnapshot %}