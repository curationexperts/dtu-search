module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  def application_name
    'DTU Digital Library - Technical University of Denmark'
  end

  # Save function area for search results 'index' view, normally
  # renders next to title. Includes just 'Folder' by default.
  def render_index_doc_actions(document, options={})   
    content = []
    content << render(:partial => 'catalog/bookmark_control', :locals => {:document=> document}.merge(options)) if has_user_authentication_provider? and current_user

    content_tag("div", content.join("\n").html_safe, :class=>"documentFunctions")
  end
  
end
