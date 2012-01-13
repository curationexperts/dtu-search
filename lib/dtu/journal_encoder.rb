module DTU
  class JournalEncoder < XmlEncoder

    def self.identifier(doc)
      doc['id'] = doc['header_id_t'].first
      doc['format'] = 'journal'
      if doc['entry_title_t'].nil?
        raise "No Journal title for journal #{doc['id']}"
      end
      doc['journal_title_facet'] = doc['entry_title_t'].first
      if doc['entry_publisher_name_t']
        #some journal records don't have publisher name
        doc['publisher_name_facet'] = doc['entry_publisher_name_t'].first
      end
        
      doc['title_s'] = doc['journal_title_facet']
    end
  end
end
