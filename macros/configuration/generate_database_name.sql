{% macro generate_database_name(custom_database_name, node) -%}
    {%- set default_database = target.database -%}
    {% set log_msg='getting custom database:\ntarget_name:' ~ target.name ~ '\ncustom_database_name:' ~ custom_database_name %}
    {% do log(log_msg, True) %}
    {%- if custom_database_name is none -%}
        {{ default_database }}
    {%- elif target.name == 'dev' -%}
        DEV_{{ custom_database_name}}
    {%- elif target.name == 'qas' -%}
        QAS_{{ custom_database_name}}
    {%- elif target.name == 'prd' -%}
        PRD_{{ custom_database_name}}
	{%- elif 'dev_pr' == target.name -%}
        DEV_{{ custom_database_name}}
    {%- elif 'qas_pr' == target.name -%}
        QAS_{{ custom_database_name}}
    {%- elif 'prd_pr' == target.name -%}
        PRD_{{ custom_database_name}}
    {%- else -%}
        DEV_{{ custom_database_name}}
    {%- endif -%}
{%- endmacro %}
