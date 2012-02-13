
jQuery(function($){
  function redirect(url){return"http://redirect.cvt.dk/?url="+encodeURIComponent(url) }

  $(".detailed-view").click(function() {
    if ($(this).hasClass('collapsed')) {
      $(this).removeClass('collapsed');
    } else {
      $(this).addClass('collapsed');
    }
		$(this).next().toggle();
	}).click()
  
});



