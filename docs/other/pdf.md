# PDF

!!! note "From PDF to website"

    We're in the process of changing our final deliverable from a PDF to (this) website.
    We're still generating the PDF from the LaTeX content in the [ekg-mm repository](https://github.com/EKGF/ekg-mm)
    but that will soon be stopped once all content has been migrated.

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
