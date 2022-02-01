# PDF

=== "Release Version"

{% with pdf_file = "/assets/ekgf-ekg-mm.pdf" %}
<object data="{{ pdf_file }}" type="application/pdf" width="100%" height="700px">
<embed src="{{ pdf_file }}" type="application/pdf" />
</object>
{% endwith %}

=== "Editor's Version"

{% with pdf_file = "/assets/ekgf-ekg-mm-editors-version.pdf" %}
<object data="{{ pdf_file }}" type="application/pdf" width="100%" height="700px">
<embed src="{{ pdf_file }}" type="application/pdf" />
</object>
{% endwith %}
