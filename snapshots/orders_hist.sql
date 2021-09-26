{% snapshot orders_hist %}
  {{
      config(
        target_schema=generate_schema_name('MART'),
        unique_key='id',
        strategy='check',
        check_cols=['status'],
        pre_hook = logging.log_model_start_event(),
        post_hook = [ "{{retail_traffic_nightly_updates()}}"," {{ logging.log_model_end_event() }}" , "{{generate_custom_audit(this)}}" ] 
        )
}}

select * from {{ source('jaffle_shop', 'orders') }}

{% endsnapshot %}