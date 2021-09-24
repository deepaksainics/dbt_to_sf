{% macro prehook_hard_del_macro(current_data_ref, scratch_snapshot_ref, unique_key) %}
    with live as (
      select *
      from {{current_data_ref}}
    ),

    snap as (
      select *
      from {{scratch_snapshot_ref}}
    ),

    deleted_records as (
      select
        {{dbt_utils.star(scratch_snapshot_ref, except=['dbt_scd_id', 'dbt_updated_at', 'dbt_valid_from', 'dbt_valid_to'])}}
        from snap
      where {{unique_key}} not in (
        select {{unique_key}} from live
      )
      and dbt_valid_to is null
    ),

    final as (
      select {{unique_key}}, false as is_deleted
      from live

      union
     
      select {{unique_key}}, true as is_deleted
      from deleted_records
    )
    select {{unique_key}} from final where is_deleted =true
{% endmacro %}