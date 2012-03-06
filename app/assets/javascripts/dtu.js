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




