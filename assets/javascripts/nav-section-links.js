/**
 * Make navigation section titles clickable by linking them to their index page.
 *
 * This script automatically detects nav sections and makes their titles
 * clickable by deriving the index URL from the first child link's path.
 *
 * For example, if a section's first child links to /use-case/client-360/,
 * the section title will link to /use-case/.
 */
(function () {
  /**
   * Derive the parent index URL from a child URL.
   * E.g., "/use-case/client-360/" -> "/use-case/"
   */
  function getParentIndexUrl(childUrl) {
    try {
      const url = new URL(childUrl, window.location.origin);
      const pathParts = url.pathname.split("/").filter(Boolean);

      if (pathParts.length >= 1) {
        // Remove the last path segment to get the parent
        pathParts.pop();
        return "/" + pathParts.join("/") + "/";
      }
    } catch (e) {
      // Fallback for relative URLs
      const pathParts = childUrl.split("/").filter(Boolean);
      if (pathParts.length >= 1) {
        pathParts.pop();
        return "/" + pathParts.join("/") + "/";
      }
    }
    return null;
  }

  /**
   * Find the first link URL in a nav section's child list.
   */
  function getFirstChildLinkUrl(navElement) {
    const firstLink = navElement.querySelector(".md-nav__list > li > a.md-nav__link");
    if (firstLink && firstLink.href) {
      return firstLink.href;
    }
    // Also try nested structure
    const nestedLink = navElement.querySelector(".md-nav__list .md-nav__link[href]");
    if (nestedLink && nestedLink.href) {
      return nestedLink.href;
    }
    return null;
  }

  function makeLabelsClickable() {
    // Find all nav items in the primary navigation that have nested navs (sections)
    const navItems = document.querySelectorAll(".md-nav--primary > .md-nav__list > li.md-nav__item");

    navItems.forEach(function (item) {
      // Skip if already processed
      if (item.dataset.sectionLinked) return;

      // Find the nested nav element
      const navElement = item.querySelector(":scope > nav.md-nav");
      if (!navElement) return;

      // Find the section title element (could be label, span, or div with md-ellipsis)
      const titleElement = item.querySelector(":scope > label.md-nav__link .md-ellipsis") ||
                           item.querySelector(":scope > .md-nav__link .md-ellipsis") ||
                           item.querySelector(":scope > span .md-ellipsis") ||
                           item.querySelector(":scope > div .md-ellipsis");

      if (!titleElement) return;

      const title = titleElement.textContent.trim();
      if (!title) return;

      // Get the first child link URL
      const firstChildUrl = getFirstChildLinkUrl(navElement);
      if (!firstChildUrl) return;

      // Derive the parent index URL
      const indexUrl = getParentIndexUrl(firstChildUrl);
      if (!indexUrl || indexUrl === "/") return;

      // Mark as processed
      item.dataset.sectionLinked = "true";

      // Find the actual label/link container to position overlay relative to it
      const labelContainer = item.querySelector(":scope > label.md-nav__link") ||
                             item.querySelector(":scope > .md-nav__link");

      if (!labelContainer) return;

      // Make label container position relative for absolute positioning
      labelContainer.style.position = "relative";

      // Create transparent clickable overlay - positioned within the label only
      const overlay = document.createElement("a");
      overlay.href = indexUrl;
      overlay.className = "ekgf-section-link-overlay";
      overlay.setAttribute("aria-label", title);
      overlay.style.cssText = [
        "position: absolute",
        "top: 0",
        "left: 0",
        "width: calc(100% - 1.2rem)",
        "height: 100%",
        "z-index: 10",
        "cursor: pointer",
        "display: block"
      ].join(";");

      overlay.addEventListener("click", function(e) {
        e.stopPropagation();
        e.preventDefault();
        window.location.href = indexUrl;
      });

      // Insert overlay inside the label container
      labelContainer.insertBefore(overlay, labelContainer.firstChild);
    });
  }

  // Run after DOM is ready and after Material's navigation is initialized
  function init() {
    setTimeout(makeLabelsClickable, 100);
    setTimeout(makeLabelsClickable, 500);
    setTimeout(makeLabelsClickable, 1000);
  }

  // Initialize on DOMContentLoaded
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }

  // Re-run on Material's instant navigation events
  if (typeof document$ !== "undefined") {
    document$.subscribe(function() {
      setTimeout(makeLabelsClickable, 100);
    });
  }
})();
