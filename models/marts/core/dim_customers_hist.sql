{{ config(
	tags=["persisted"],
    materialized = 'incremental',
	transient=false,
    unique_key = 'customer_id',
	pre_hook = logging.log_model_start_event(),
    post_hook = [ "{{retail_traffic_nightly_updates()}}"," {{ logging.log_model_end_event() }}" , "{{generate_custom_audit(this)}}" ] 
    ) 
}}
with dim_customer_hist as (
    select * from {{ ref('dim_customers') }}
      {% if is_incremental() %}
      where MOST_RECENT_ORDER_DATE >= (select max(MOST_RECENT_ORDER_DATE) from {{ this }})
      and MOST_RECENT_ORDER_DATE is not null
      {% endif %}
)
select * from dim_customer_hist