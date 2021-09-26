{# This macro will populate the custom Audit table which will have the model name, Invocation ID,
run start time, run end time, count of rows, event full refresh flag and run duration for a model 
- This macro can be called in a post hook of each model which is using invocation id
#}

--{% macro generate_custom_audit(model_name) %}
{%- set audit_schema=logging.generate_schema_name('DBT_AUDIT',none) -%}

{% do log(audit_schema, true)%}

{%- set source_relation = adapter.get_relation(
      database=target.database,
      schema=audit_schema,
      identifier="DBT_AUDIT_LOG_CUSTOM") -%}

{{ log("Source Relation: " ~ source_relation, info=true) }}

{% if source_relation is none %}

CREATE TABLE {{database}}.{{audit_schema}}."DBT_AUDIT_LOG_CUSTOM" 
("MODEL_NAME" STRING,
"INVOCATION_ID" STRING,
"MODEL_START_TIMESTAMP" TIMESTAMP_NTZ(9),
"MODEL_END_TIMESTAMP" TIMESTAMP_NTZ(9),
"ROW_COUNT" INTEGER,
"EVENT_IS_FULL_REFRESH" BOOLEAN,
"DURATION_IN_MIN" NUMBER(38,2) );


commit;

{% endif %}

INSERT INTO 
{{database}}.{{audit_schema}}."DBT_AUDIT_LOG_CUSTOM"
(
MODEL_NAME,
INVOCATION_ID,
MODEL_START_TIMESTAMP,
MODEL_END_TIMESTAMP,
ROW_COUNT,
EVENT_IS_FULL_REFRESH,
DURATION_IN_MIN
)

    SELECT 
    model_name,
    invocation_id,
    model_start_timestamp,
    model_end_timestamp,
    row_count,
    event_is_full_refresh,
    TIMESTAMPDIFF (second, model_start_timestamp, model_end_timestamp)/60
    FROM
    (SELECT 
    '{{this.name}}' as model_name,
    '{{invocation_id}}' as invocation_id,
      (select event_timestamp FROM {{database}}.{{audit_schema}}."DBT_AUDIT_LOG"
        WHERE event_model='{{this.name}}' AND invocation_id='{{invocation_id}}' and event_name='model deployment started' 
        and event_timestamp IS NOT NULL) as model_start_timestamp,
      (select event_timestamp FROM {{database}}.{{audit_schema}}."DBT_AUDIT_LOG"
       WHERE event_model='{{this.name}}' AND invocation_id='{{invocation_id}}' and event_name='model deployment completed' 
       and event_timestamp IS NOT NULL) as model_end_timestamp ,
      (select count(*) from {{model_name}} where DBT_INVOCATION_ID='{{invocation_id}}') as row_count,
      (select event_is_full_refresh FROM {{database}}.{{audit_schema}}."DBT_AUDIT_LOG"
       WHERE event_model='{{this.name}}' AND invocation_id='{{invocation_id}}' 
       and event_name='model deployment completed' and event_timestamp IS NOT NULL) as event_is_full_refresh)

    ;

commit;

{% endmacro %}