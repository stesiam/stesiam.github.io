function updateThemeImages() {
  const theme = document.documentElement.getAttribute("data-theme");
  document.querySelectorAll(".theme-switch-img").forEach(img => {
    const newSrc = theme === "dark" ? img.dataset.darkSrc : img.dataset.lightSrc;
    if (img.src !== newSrc) {
      img.src = newSrc;
    }
  });
}

// Update on page load
document.addEventListener("DOMContentLoaded", updateThemeImages);

// Observe for changes to the data-theme attribute
const observer = new MutationObserver(mutations => {
  mutations.forEach(mutation => {
    if (mutation.attributeName === "data-theme") {
      updateThemeImages();
    }
  });
});

observer.observe(document.documentElement, { attributes: true });
