---
title: "Contents - Functional Programming in Kotlin"
layout: post
date: "2016-10-26T00:00:00-05:00"
published: true
series: "Functional Programming in Scala in Kotlin"
---

<div class="panel seriesNote">
    <ul>
        {% assign count = '0' %}
        {% for post in site.posts reversed %}
            {% if post.series == page.series %}
                {% capture count %}{{ count | plus: '1' }}{% endcapture %}
                <li>Part {{ count }} - 
                {% if page.url == post.url %}
                    This Article
                {% else %}
                    <a href="{{post.url}}">{{post.title}}</a>
                {% endif %}
                </li>
            {% endif %}
        {% endfor %}
    </ul>
</div>

