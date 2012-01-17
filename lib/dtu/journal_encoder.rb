module DTU
  class JournalEncoder < XmlEncoder

    def self.identifier(id, doc)
      doc['id'] = doc['header_id_t'].first
      doc['metastore_id_s'] = id
      doc['format'] = 'journal'
      if doc['entry_title_t'].nil?
        raise "No Journal title for journal #{doc['id']} -- #{id}"
      end
      doc['title_t'] = doc['entry_title_t']
## Index published date as date
## Index ingest date as a date
## Index controlled terms as a facet
## Index title as a common field

      #doc['journal_title_facet'] = doc['title_t']
      if doc['entry_publisher_name_t']
        #some journal records don't have publisher name
        doc['publisher_name_facet'] = doc['entry_publisher_name_t'].first
      end
        
    end
  end
end
