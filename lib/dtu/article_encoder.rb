module DTU
  class ArticleEncoder < XmlEncoder

    def self.identifier(id, doc)
      doc['id'] = doc['localinfo_key_t'].first
      doc['metastore_id_s'] = id
      doc['format'] = 'article'
      doc['author_name_facet'] = doc['author_name_t']
      doc['title_t'] = doc['article_title_t']
      j_title = doc['journal_title_t'] || doc['journal_ctitle_t']
      if j_title.nil?
        raise "No Journal title for article #{doc['id']} -- #{id}"
      end
    end
  end
end
