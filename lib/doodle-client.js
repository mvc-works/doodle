(function() {
  var source;

  source = new EventSource('/?events');

  source.onmessage = function(e) {
    console.log('e:', e);
    if (window.doodle != null) {
      return window.doodle();
    } else {
      return window.location.reload();
    }
  };

  console.log('js loaded');

}).call(this);
