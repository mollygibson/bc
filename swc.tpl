---
layout: lesson
root: ../..
title: Some Title
---
{% extends 'markdown.tpl' %}

{% block in_prompt %}
{% endblock in_prompt %}

{% block input %}
~~~
{{ cell.input }}
~~~
{% endblock input %}
