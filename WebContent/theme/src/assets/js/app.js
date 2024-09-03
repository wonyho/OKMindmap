import $ from 'jquery';
import 'bootstrap';
import PerfectScrollbar from 'perfect-scrollbar';
// import './jquery.sticky.js';

window.$ = window.jQuery = $;
window.__$ = window.__jQuery = $;

window.PerfectScrollbar = PerfectScrollbar;

window.onLoadIFrame = function(self) {
  $(self).parent().removeClass('skeleton-loading');
  self.style.height = (self.contentDocument.body.scrollHeight + 5) +'px';
};

$(document).ready(function() {
  // $('.sticker').each(function() {
  //   $(this).sticky({
  //     topSpacing: $(this).data('topSpacing') || 0,
  //     bottomSpacing: $(this).data('bottomSpacing') || 0
  //   });
  // });

  $('.dropdown-iframe').each(function() {
    var target = $(this).find('iframe');

    $(this).on('shown.bs.dropdown', function() {
      $(target).parent().addClass('skeleton-loading');
      $(target).attr('src', $(target).data('src'));
      $('[data-toggle="tooltip"]').tooltip('hide');
    });

    $(this).on('hidden.bs.dropdown', function() {
      $(target).attr('src', null);
    });
  });

  $('.modal-iframe').each(function() {
    var target = $(this).find('iframe');

    $(this).on('shown.bs.modal', function() {
      $(target).parent().addClass('skeleton-loading');
      $(target).attr('src', $(target).data('src'));
      $('[data-toggle="tooltip"]').tooltip('hide');
    });
    
    $(this).on('hidden.bs.modal', function() {
      $(target).attr('src', null);
    });
  });

  $('[data-toggle="tooltip"]').tooltip();
});
