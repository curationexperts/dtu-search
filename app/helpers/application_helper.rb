module ApplicationHelper
  def application_name
    'DTU Digital Library - Technical University of Denmark'
  end

  def link_to_fulltext(document)
    title = CGI.escape document['title_t'].first if document['title_t']
    doi = CGI.escape(document['recordid_doi_t'].first) if document['recordid_doi_t'] 
    author = CGI.escape(document['author_name_t'].first) if document['author_name_t'] 
    issue = document['journal_issue_t'].first if document['journal_issue_t']
    year = document['journal_year_t'].first if document['journal_year_t']
    vol = document['journal_vol_t'].first if document['journal_vol_t']
    page = document['journal_page_t'].first if document['journal_page_t']
    issn = document['journal_issn_t'].first if document['journal_issn_t']
    "http://sfx.cvt.dk/sfx_local?rft.jtitle=#{title}&amp;rft.issn=#{issn}&amp;rft.pages=#{page}&amp;rft.spage=#{page}&amp;rft.volume=#{vol}&amp;rft.issue=#{issue}&amp;rft.date=#{year}&amp;rft.atitle=#{title}&amp;rft.doi=#{ doi }&amp;rft.au=#{author}&amp;rfr_id=info:sid/dlib.dtu.dk:DTUDigitalLibrary".html_safe
  end

  def show_authors(document)
    document['author_name_t'].map {|author| link_to(author, add_facet_params_and_redirect('author_name_facet', author)) }.join(' &#8226; ').html_safe  if document['author_name_t']
  end
end
