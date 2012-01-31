module DTU
  class JournalEncoder < XmlEncoder

    def self.identifier(id, doc)
      doc['id'] = doc['header_id_t'].first
      doc['metastore_id_s'] = id
      doc['format'] = 'journal'
      if doc['entry_title_t'].nil?
        raise "No Journal title for journal #{doc['id']} -- #{id}"
      end
      doc['title_t'] = doc['header_title_t']
      doc['title_sort'] = doc['title_t'].first

      if doc['entry_publisher_name_t']
        #some journal records don't have publisher name
        doc['publisher_name_facet'] = doc['entry_publisher_name_t'].first
      end
      keywords = ([] << doc['entry_classification_broader-term_t'] << doc['entry_classification_narrower-term_t']).flatten
      doc['keywords_facet'] = keywords       
    end
  end
end
