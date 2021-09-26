{% macro get_audit_schema() %}

   {{ return(generate_schema_name('DBT_AUDIT',none)) }} 

{% endmacro %}