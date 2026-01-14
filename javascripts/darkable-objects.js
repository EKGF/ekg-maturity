/**
 * Inline PlantUML SVGs (rendered via mkdocs-build-plantuml) so that:
 * - Clickable hyperlinks keep working
 * - Light/dark variants can be swapped even though Material only supports
 *   #darkable on <img>, not <object>
 * - Backgrounds remain transparent because we inject the SVG directly into DOM
 */
(function () {
  if (window.__ekgfInlineDiagramsInitialized) {
    return;
  }
  window.__ekgfInlineDiagramsInitialized = true;

  const DARK_SCHEME = 'slate';
  const OBJECT_SELECTOR = 'object[type="image/svg+xml"][data*="#darkable"]';
  const diagrams = new Set();
  const MAX_WIDTH = 1400;
  const VIEWPORT_PADDING = 64;
  let resizeTimeout = null;

  function getPaletteHost() {
    return document.body || document.documentElement;
  }

  function isDarkMode() {
    const host = getPaletteHost();
    return (host && host.getAttribute('data-md-color-scheme')) === DARK_SCHEME;
  }

  function getVariantPaths(rawValue) {
    if (!rawValue) return null;
    const cleaned = rawValue.replace('#darkable', '');
    const match = cleaned.match(/(.*?)(\.svg(?:\?.*)?)$/i);
    if (!match) return null;

    const light = cleaned.replace(/_dark(?=\.svg(\?.*)?$)/i, '');
    const dark = light.replace(/\.svg(\?.*)?$/i, '_dark.svg');
    return { light, dark };
  }

  function getNaturalWidth(svg) {
    const viewBox = svg.getAttribute('viewBox');
    if (viewBox) {
      const parts = viewBox.trim().split(/\s+/);
      if (parts.length === 4) {
        const width = parseFloat(parts[2]);
        if (!Number.isNaN(width)) {
          return width;
        }
      }
    }
    const widthAttr = svg.getAttribute('width');
    if (widthAttr) {
      const numeric = parseFloat(widthAttr);
      if (!Number.isNaN(numeric)) {
        return numeric;
      }
    }
    return null;
  }

  function getTargetWidth(naturalWidth) {
    const viewportCap = Math.max(
      320,
      Math.min(window.innerWidth - VIEWPORT_PADDING, MAX_WIDTH)
    );
    if (naturalWidth) {
      return Math.min(viewportCap, naturalWidth);
    }
    return viewportCap;
  }

  function applySizing(diagram, svg) {
    const targetWidth = getTargetWidth(diagram.naturalWidth);
    diagram.container.style.width = `${targetWidth}px`;
    svg.style.width = `${targetWidth}px`;
    svg.style.maxWidth = '100%';
    svg.style.height = 'auto';
    svg.removeAttribute('height');
  }

  function fixStartEndStateColors(svg) {
    if (!isDarkMode()) return;
    // Fix hardcoded #222222 fill/stroke colors for start/end states in dark mode
    // Start state: one filled circle (orange fill + stroke)
    // End state: smaller filled circle inside larger non-filled circle (outer: orange stroke only, inner: orange fill)

    // Helper to get bounding box of a polygon
    function getBoundingBox(polygon) {
      const points = polygon.getAttribute('points');
      if (!points) return null;
      const coords = points.split(/[\s,]+/).map(parseFloat).filter(n => !isNaN(n));
      if (coords.length < 4) return null;

      let minX = coords[0], maxX = coords[0];
      let minY = coords[1], maxY = coords[1];
      for (let i = 2; i < coords.length; i += 2) {
        minX = Math.min(minX, coords[i]);
        maxX = Math.max(maxX, coords[i]);
        minY = Math.min(minY, coords[i + 1]);
        maxY = Math.max(maxY, coords[i + 1]);
      }
      return { minX, maxX, minY, maxY, width: maxX - minX, height: maxY - minY };
    }

    // Helper to check if two bounding boxes overlap significantly (indicating nested circles)
    function areNested(bb1, bb2, threshold = 0.7) {
      if (!bb1 || !bb2) return false;
      const center1 = { x: (bb1.minX + bb1.maxX) / 2, y: (bb1.minY + bb1.maxY) / 2 };
      const center2 = { x: (bb2.minX + bb2.maxX) / 2, y: (bb2.minY + bb2.maxY) / 2 };
      const distance = Math.sqrt(Math.pow(center1.x - center2.x, 2) + Math.pow(center1.y - center2.y, 2));
      const avgSize = (bb1.width + bb1.height + bb2.width + bb2.height) / 4;
      return distance < avgSize * threshold;
    }

    // Find all polygons with dark fill/stroke (start/end states)
    const candidatePolygons = Array.from(svg.querySelectorAll('polygon')).filter((polygon) => {
      const fill = polygon.getAttribute('fill');
      const style = polygon.getAttribute('style') || '';
      const hasDarkFill = fill === '#222222' || fill === '#222';
      const hasDarkStroke = style.includes('stroke:#222222') || style.includes('stroke:#222');
      return hasDarkFill || hasDarkStroke;
    });

    // Group polygons that are nested (end states have two circles)
    const processed = new Set();
    candidatePolygons.forEach((polygon) => {
      if (processed.has(polygon)) return;

      const bb1 = getBoundingBox(polygon);
      if (!bb1) return;

      // Look for a nearby polygon that might be the other circle of an end state
      let nestedPolygon = null;
      for (const other of candidatePolygons) {
        if (other === polygon || processed.has(other)) continue;
        const bb2 = getBoundingBox(other);
        if (bb2 && areNested(bb1, bb2)) {
          nestedPolygon = other;
          break;
        }
      }

      if (nestedPolygon) {
        // This is an end state: two nested circles
        processed.add(polygon);
        processed.add(nestedPolygon);

        const bb2 = getBoundingBox(nestedPolygon);
        const isOuter = bb1.width > bb2.width || bb1.height > bb2.height;
        const outer = isOuter ? polygon : nestedPolygon;
        const inner = isOuter ? nestedPolygon : polygon;

        // Outer circle: orange stroke, transparent fill
        const outerStyle = outer.getAttribute('style') || '';
        outer.setAttribute('fill', 'transparent');
        outer.setAttribute('stroke', '#ff6f00');
        if (outerStyle) {
          outer.setAttribute('style', outerStyle
            .replace(/stroke:#222222/g, 'stroke:#ff6f00')
            .replace(/stroke:#222([^0-9])/g, 'stroke:#ff6f00$1')
            .replace(/fill:#222222/g, 'fill:transparent')
            .replace(/fill:#222([^0-9])/g, 'fill:transparent$1'));
        }

        // Inner circle: orange fill and stroke
        const innerStyle = inner.getAttribute('style') || '';
        inner.setAttribute('fill', '#ff6f00');
        inner.setAttribute('stroke', '#ff6f00');
        if (innerStyle) {
          inner.setAttribute('style', innerStyle
            .replace(/stroke:#222222/g, 'stroke:#ff6f00')
            .replace(/stroke:#222([^0-9])/g, 'stroke:#ff6f00$1')
            .replace(/fill:#222222/g, 'fill:#ff6f00')
            .replace(/fill:#222([^0-9])/g, 'fill:#ff6f00$1'));
        }
      } else {
        // This is a start state: single filled circle
        processed.add(polygon);
        const style = polygon.getAttribute('style') || '';
        polygon.setAttribute('fill', '#ff6f00');
        polygon.setAttribute('stroke', '#ff6f00');
        if (style) {
          polygon.setAttribute('style', style
            .replace(/stroke:#222222/g, 'stroke:#ff6f00')
            .replace(/stroke:#222([^0-9])/g, 'stroke:#ff6f00$1')
            .replace(/fill:#222222/g, 'fill:#ff6f00')
            .replace(/fill:#222([^0-9])/g, 'fill:#ff6f00$1'));
        }
      }
    });
  }

  function renderDiagram(diagram) {
    const markup =
      (isDarkMode() ? diagram.darkMarkup : diagram.lightMarkup) ||
      diagram.lightMarkup;
    if (!markup) return;
    diagram.container.innerHTML = markup;
    const svg = diagram.container.querySelector('svg');
    if (svg) {
      diagram.naturalWidth = getNaturalWidth(svg) || diagram.naturalWidth;
      applySizing(diagram, svg);
      fixStartEndStateColors(svg);
    }
  }

  async function inlineDiagram(obj) {
    const variants = getVariantPaths(obj.getAttribute('data'));
    if (!variants) return;

    const container = document.createElement('div');
    container.classList.add('ekgf-diagram');
    container.setAttribute('role', 'img');

    obj.replaceWith(container);

    try {
      const [lightMarkup, darkMarkup] = await Promise.all([
        fetch(variants.light).then((response) => response.text()),
        fetch(variants.dark)
          .then((response) => response.text())
          .catch(() => null),
      ]);

      const diagram = {
        container,
        lightMarkup,
        darkMarkup: darkMarkup || lightMarkup,
        naturalWidth: null,
      };

      diagrams.add(diagram);
      renderDiagram(diagram);
    } catch (error) {
      console.error('[darkable] Failed to inline SVG diagram', error);
    }
  }

  async function transformObjects(root = document) {
    const objects = Array.from(root.querySelectorAll(OBJECT_SELECTOR));
    diagrams.clear();
    await Promise.all(objects.map(inlineDiagram));
  }

  const paletteObserver = new MutationObserver(() => {
    diagrams.forEach(renderDiagram);
  });

  const paletteHost = getPaletteHost();
  if (paletteHost) {
    paletteObserver.observe(paletteHost, {
      attributes: true,
      attributeFilter: ['data-md-color-scheme'],
    });
  }

  async function initPage() {
    await transformObjects();
  }

  if (window.document$ && window.document$.subscribe) {
    document$.subscribe(() => {
      initPage();
    });
  }

  initPage();

  window.addEventListener('resize', () => {
    if (resizeTimeout) {
      clearTimeout(resizeTimeout);
    }
    resizeTimeout = setTimeout(() => {
      diagrams.forEach(renderDiagram);
    }, 150);
  });
})();
