(function () {
  // Listen for clicks on palette toggle labels using event delegation
  // Using click on labels instead of change on radios to handle the first-click case
  // where no radio is initially checked
  document.addEventListener("click", function (event) {
    // Check if the clicked element is a palette toggle label or its child (SVG icon)
    var label = event.target.closest('label[for^="__palette_"]');
    if (label) {
      // Small delay to let Material for MkDocs process the change and update local storage
      setTimeout(function () {
        location.reload();
      }, 100);
    }
  });
})();
