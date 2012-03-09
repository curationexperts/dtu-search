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
      pub_date('publication_year_t', doc)
      doc['keywords_facet'] = doc['ctrlT_term_t']
      doc['identifier_s'] = [doc['publication_isbn_t'], doc['publication_newisbn_t'], doc['id']].flatten.compact
    end
  end
end

