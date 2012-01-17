module DTU
  class BookEncoder < XmlEncoder

    def self.identifier(id, doc)
      doc['id'] = doc['localInfo_key_t'].first
      doc['metastore_id_s'] = id
      doc['format'] = 'book'
      doc['author_name_facet'] = doc['author_name_t']
      doc['author_sort'] = doc['author_name_t'].first if doc['author_name_t']
      doc['title_t'] = doc['ebook_title_t']
      doc['title_sort'] = doc['title_t'].first
      doc['pub_date'] = doc['publication_year_t'].first if doc['publication_year_t']
      doc['keywords_facet'] = doc['ctrlT_term_t']
    end
  end
end

