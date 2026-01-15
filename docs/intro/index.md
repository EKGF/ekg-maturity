---
hide:
- title
- toc
---
<div id="maturity-structure-diagram" style="width: 100%"></div>
<script>
(function() {
  function isDarkMode() {
    const scheme = document.body?.getAttribute('data-md-color-scheme') ||
                   document.documentElement?.getAttribute('data-md-color-scheme');
    return scheme === 'slate';
  }

  function applyTheme(svgEl) {
    if (!svgEl) return;
    const dark = isDarkMode();
    svgEl.querySelectorAll('.level-row').forEach(el => {
      el.style.fill = dark ? 'transparent' : '#fefce8';
    });
    svgEl.querySelectorAll('.level-text').forEach(el => {
      el.style.fill = dark ? '#f7fafc' : '#1a1a1a';
    });
    svgEl.querySelectorAll('.level-subtitle').forEach(el => {
      el.style.fill = dark ? '#a0aec0' : '#666666';
    });
    svgEl.querySelectorAll('.grid-line').forEach(el => {
      el.style.stroke = dark ? '#6b7280' : '#d4d4d4';
    });
    svgEl.querySelectorAll('.arrow').forEach(el => {
      el.style.stroke = dark ? '#fbbf24' : '#1a1a1a';
    });
    // Also update the arrowhead marker
    svgEl.querySelectorAll('#arrowhead polygon').forEach(el => {
      el.style.fill = dark ? '#fbbf24' : '#1a1a1a';
    });
  }

  fetch('../assets/ekg-maturity-structure.svg')
    .then(r => r.text())
    .then(svg => {
      const container = document.getElementById('maturity-structure-diagram');
      container.innerHTML = svg;
      const svgEl = container.querySelector('svg');
      if (svgEl) {
        svgEl.style.width = '100%';
        svgEl.style.height = 'auto';
        applyTheme(svgEl);
      }

      // Watch for theme changes on both body and html
      const observer = new MutationObserver(() => applyTheme(container.querySelector('svg')));
      if (document.body) {
        observer.observe(document.body, { attributes: true, attributeFilter: ['data-md-color-scheme'] });
      }
      if (document.documentElement) {
        observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-md-color-scheme'] });
      }
    });
})();
</script>
