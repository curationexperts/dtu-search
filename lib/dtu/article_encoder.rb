module DTU
  class ArticleEncoder < XmlEncoder

    def self.identifier(id, doc)
      doc['id'] = doc['localinfo_key_t'].first
      doc['metastore_id_s'] = id
      doc['format'] = 'article'
      doc['author_name_facet'] = doc['author_name_t']
      doc['title_s'] = doc['article_title_t'].first
      if doc['journal_title_t'].nil?
        raise "No Journal title for article #{doc['id']}"
      end
      doc['journal_title_facet'] = doc['journal_title_t'].first
    end
  end
end
