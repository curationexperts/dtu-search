module ApplicationHelper
  def link_to_fulltext(document)
    # grab the info for generating local urls if it's in the document
    document_source = document.fetch("localinfo_source_t", []).first  # case sensitive field name!  localinfo_source_t NOT localInfo_source_t
    fulltext_local_path = document.fetch("fulltext_local_t", []).first 
    key = document.fetch("localinfo_systemno_t", []).first # sf:art/sf:localinfo/sf:systemno
    
    # Generate SFX link unless all of the info for generating local urls is available
    if document_source.nil? || fulltext_local_path.nil? || key.nil?
      title = CGI.escape document['title_t'].first if document['title_t']
      doi = CGI.escape(document['recordid_doi_t'].first) if document['recordid_doi_t'] 
      author = CGI.escape(document['author_name_t'].first) if document['author_name_t'] 
      issue = document['journal_issue_t'].first if document['journal_issue_t']
      year = document['journal_year_t'].first if document['journal_year_t']
      vol = document['journal_vol_t'].first if document['journal_vol_t']
      page = document['journal_page_t'].first if document['journal_page_t']
      issn = document['journal_issn_t'].first if document['journal_issn_t']
      return "http://sfx.cvt.dk/sfx_local?rft.jtitle=#{title}&amp;rft.issn=#{issn}&amp;rft.pages=#{page}&amp;rft.spage=#{page}&amp;rft.volume=#{vol}&amp;rft.issue=#{issue}&amp;rft.date=#{year}&amp;rft.atitle=#{title}&amp;rft.doi=#{ doi }&amp;rft.au=#{author}&amp;rfr_id=info:sid/dlib.dtu.dk:DTUDigitalLibrary".html_safe
    else
      pi = fulltext_local_path[document_source.length+1..fulltext_local_path.length]
      referrer_id = "info:sid/dlib.dtu.dk:DTUDigitalLibraryBlacklight" # this is the identifier the running application uses. Maybe Blacklight application should use something slightly different.
      redirect_query_url = "http://dtu-ftc.cvt.dk/cgi-bin/fulltext/#{document_source}?pi=#{pi}&key=#{key}&rfr_id=#{referrer_id}"
      return "http://redirect.cvt.dk?url=#{CGI.escape(redirect_query_url)}".html_safe
    end
  end

  def show_authors(document)
    document['author_name_t'].map {|author| link_to(author, add_facet_params_and_redirect('author_name_facet', author)) }.join(' &#8226; ').html_safe  if document['author_name_t']
  end
end
