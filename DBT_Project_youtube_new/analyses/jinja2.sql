{%- set apples = ["Gala","Red Delicisious","Fuji","Honeycrisp","McIntosch","Pinklady"] -%}

{% for i in apples %}

    {% if i != "Fuji" %}
        {{ i }}
    {% else %}
         i hate {{ i }}
    {% endif %}

{% endfor %}