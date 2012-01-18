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
      pub_date('journal_year_t', doc)
      doc['keywords_facet'] = doc['ctrlt_text_t']
    end
  end
end
