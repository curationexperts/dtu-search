class Article
  cattr_accessor :fields

  @@fields = {'journal_publisher_t' => 'Publisher', 'journal_title_t' =>'Journal', 'journal_issn_t' => 'ISSN', 'recordid_doi_t' => 'DOI', 'article_language_t' => 'Language', 'ctrlt_text_t' => 'Keywords', 'affiliation_name_t' => 'Affiliation'}

end
