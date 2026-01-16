<script>
document.addEventListener("DOMContentLoaded", function() {
  const observer = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const el = entry.target;
        const options = JSON.parse(el.getAttribute('data-hc'));
        
        // Initialize the Highcharts plot only when visible
        Highcharts.chart(el.id, options);
        
        observer.unobserve(el); // Stop watching once loaded
      }
    });
  }, { rootMargin: "100px" }); // Load 100px before it enters view

  document.querySelectorAll('.lazy-highchart').forEach(chart => {
    observer.observe(chart);
  });
});
</script>