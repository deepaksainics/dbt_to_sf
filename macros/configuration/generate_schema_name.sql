{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is none -%}
        {{ default_schema }} 
    {%- elif 'prd' == target.name -%}
        {{ custom_schema_name | trim }}
    {%- elif 'qas' == target.name -%}
        {{ custom_schema_name | trim }}
    {%- elif 'dev' == target.name -%}
        {{ custom_schema_name | trim }}
    {%- elif 'dev_pr' == target.name -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- elif 'qas_pr' == target.name -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- elif 'prd_pr' == target.name -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- else -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}