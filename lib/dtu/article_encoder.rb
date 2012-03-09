module DTU
  class ArticleEncoder < XmlEncoder

    def self.identifier(id, doc)
      doc['id'] = doc['localinfo_key_t'].first
      doc['metastore_id_s'] = id
      doc['format'] = 'article'
      doc['author_name_facet'] = doc['author_name_t']
      doc['author_sort'] = doc['author_name_t'].first if doc['author_name_t']
      doc['title_t'] = doc['article_title_t']
      doc['title_sort'] = doc['title_t'].first
      doc['journal_title_facet'] = doc['journal_title_t'].first if doc['journal_title_t']
      pub_date('journal_year_t', doc)
      doc['identifier_s'] = [doc['recordid_doi_t'], doc['journal_issn_t'], doc['journal_eissn_t'], doc['id'], doc['recordid_pii_t']].flatten.compact
      doc['keywords_facet'] = doc['ctrlt_text_t']
    end
  end
end
