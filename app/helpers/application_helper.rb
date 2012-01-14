module ApplicationHelper
  def application_name
    'DTU Digital Library - Technical University of Denmark'
  end

  def link_to_fulltext(document)
logger.warn "title: " + document['journal_title_t'].inspect
logger.warn "page: " + document['journal_page_t'].inspect
logger.warn "vol: " + document['journal_vol_t'].inspect
logger.warn "recordid_doi_t: " + document['recordid_doi_t'].inspect
logger.warn "recordid_doi_t: " + document['recordid_doi_t'].inspect
logger.warn "author_name_t: " + document['author_name_t'].inspect
logger.warn "title_s: " + document['title_s'].inspect

    "http://sfx.cvt.dk/sfx_local?rft.jtitle=#{CGI.escape document['journal_title_t'].first}&amp;rft.issn=#{document['journal_issn_t'].first }&amp;rft.pages=#{document['journal_page_t'].first }&amp;rft.spage=#{document['journal_page_t'].first }&amp;rft.volume=#{document['journal_vol_t'].first }&amp;rft.issue=#{document['journal_issue_t']}&amp;rft.date=#{document['journal_year_t']}&amp;rft.atitle=#{CGI.escape document['title_s'] }&amp;rft.doi=#{ CGI.escape(document['recordid_doi_t'].first) if document['recordid_doi_t'] }&amp;rft.au=#{CGI.escape document['author_name_t'].first }&amp;rfr_id=info:sid/dlib.dtu.dk:DTUDigitalLibrary".html_safe
  end
end
