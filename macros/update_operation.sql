{% macro update_customer_name(tab_name,old_cust_name,new_cust_name) %}
{% set sql %}
    update {{tab_name}} set first_name='{{new_cust_name}}' where first_name='{{old_cust_name}}'
{% endset %}

{% do run_query(sql) %}
{% do log("Query Executed Successfully", info=True) %}
{% endmacro %}