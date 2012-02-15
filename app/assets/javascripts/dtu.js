jQuery(function($){
  function redirect(url){return"http://redirect.cvt.dk/?url="+encodeURIComponent(url) }

  $("h2.detailed-view").click(function() {
    if ($(this).hasClass('collapsed')) {
      $(this).removeClass('collapsed');
    } else {
      $(this).addClass('collapsed');
    }
	 	$(this).next().toggle();
	}).click();
  
});

(function($) {
    //change form submit toggle to checkbox
     Blacklight.do_bookmark_toggle_behavior = function() {
      $('form.bookmark_toggle').bl_checkbox_submit({          
          checked_label: "Saved",
          unchecked_label: "Not Saved",
          progress_label: "Saving...",
          //css_class is added to elements added, plus used for id base
          css_class: "toggle_bookmark"    
      }); 
     };
})(jQuery);




