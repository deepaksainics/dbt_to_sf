---Example for IF Else-----

{% set temperature = 60 -%}

On a day like this, I especially like 

{%- if temperature >70 %}

a refreshing mango sorbet.

{% else -%}

A decadent chocolate ice cream.

{% endif -%}

On a day like this, I especially like

a refreshing mango sorbet

----Example for Loop-----

{%- set flavors = ['chocolate', 'vanilla', 'strawberry'] %}

{% for flavor in flavors -%}

Today I want {{ flavor }} ice cream!

{% endfor %}