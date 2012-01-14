module ApplicationHelper
  def application_name
    'DTU Digital Library - Technical University of Denmark'
  end

  def link_to_fulltext(document)
logger.warn "title: " + document['journal_title_t'].inspect
logger.warn "page: " + document['journal_page_t'].inspect
logger.warn "vol: " + document['journal_vol_t'].inspect
logger.warn "recordid_doi_t: " + document['recordid_doi_t'].inspect
logger.warn "author_name_t: " + document['author_name_t'].inspect
logger.warn "title_s: " + document['title_s'].inspect

    title = CGI.escape document['title_s'] if document['title_s']
    doi = CGI.escape(document['recordid_doi_t'].first) if document['recordid_doi_t'] 
    author = CGI.escape(document['author_name_t'].first) if document['author_name_t'] 
    issue = document['journal_issue_t'].first if document['journal_issue_t']
    year = document['journal_year_t'].first if document['journal_year_t']
    "http://sfx.cvt.dk/sfx_local?rft.jtitle=#{CGI.escape document['journal_title_t'].first}&amp;rft.issn=#{document['journal_issn_t'].first }&amp;rft.pages=#{document['journal_page_t'].first }&amp;rft.spage=#{document['journal_page_t'].first }&amp;rft.volume=#{document['journal_vol_t'].first }&amp;rft.issue=#{issue}&amp;rft.date=#{year}&amp;rft.atitle=#{title}&amp;rft.doi=#{ doi }&amp;rft.au=#{author}&amp;rfr_id=info:sid/dlib.dtu.dk:DTUDigitalLibrary".html_safe
  end

  def show_authors(document)
    document['author_name_t'].map {|author| link_to(author, add_facet_params_and_redirect('author_name_facet', author)) }.join(' &#8226; ').html_safe  if document['author_name_t']
  end
end
