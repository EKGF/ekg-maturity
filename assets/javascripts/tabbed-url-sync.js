/**
 * Sync tab state with URL hash.
 * When a tab is clicked, the URL hash is updated.
 * When the page loads with a hash, the corresponding tab is selected.
 */
(function () {
  if (window.__ekgfTabbedUrlSyncInitialized) {
    return;
  }
  window.__ekgfTabbedUrlSyncInitialized = true;

  function updateUrlHash(tabId) {
    if (tabId && history.replaceState) {
      history.replaceState(null, '', '#' + tabId);
    }
  }

  function selectTabFromHash() {
    const hash = location.hash.slice(1);
    if (!hash) return;

    const input = document.getElementById(hash);
    if (input && input.type === 'radio' && input.name.startsWith('__tabbed_')) {
      input.checked = true;
    }
  }

  function initTabListeners() {
    const tabInputs = document.querySelectorAll(
      'input[type="radio"][name^="__tabbed_"]'
    );

    tabInputs.forEach((input) => {
      input.addEventListener('change', function () {
        if (this.checked && this.id) {
          updateUrlHash(this.id);
        }
      });
    });
  }

  function init() {
    selectTabFromHash();
    initTabListeners();
  }

  // Handle MkDocs Material instant navigation
  if (window.document$ && window.document$.subscribe) {
    document$.subscribe(() => {
      init();
    });
  }

  // Also run on initial load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Handle back/forward navigation
  window.addEventListener('hashchange', selectTabFromHash);
})();
