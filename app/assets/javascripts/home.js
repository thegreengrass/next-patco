$(document).ready(function() {
  hookUpCarousel();
  stopTimePageReload();
});

function hookUpCarousel() {
  toPhila = $('.upcoming-trains.to-phila').owlCarousel({
    items: 2
  });

  $('.navigation.to-phila .previous').click(function(e) {
    e.preventDefault();
    toPhila.trigger('prev');
  });

  $('.navigation.to-phila .next').click(function(e) {
    e.preventDefault();
    toPhila.trigger('next');
  });

  toLindenwold = $('.upcoming-trains.to-lindenwold').owlCarousel({
    items: 2
  });

  $('.navigation.to-lindenwold .previous').click(function(e) {
    e.preventDefault();
    toLindenwold.trigger('prev');
  });

  $('.navigation.to-lindenwold .next').click(function(e) {
    e.preventDefault();
    toLindenwold.trigger('next');
  });
}

function stopTimePageReload() {
  if ($('body.action-stop_times').length > 0) {
    setTimeout(function() {
      window.location.reload();
    }, 30000);
  }
}
