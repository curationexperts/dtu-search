module DTU::DocumentExtensions
  
  def self.extended(document)
    # Register our exportable formats, we inherit these from MarcExport    
    DTU::DocumentExtensions.register_export_formats( document )
  end
  
  def self.register_export_formats(document)
    document.will_export_as(:ris)
  end
  
  # Generates RIS export for books, journal articles and (not supported by RIS) journals
  def export_as_ris
    export_text = ""
    # if format == 'book'
    format = fetch("format")
    titles = fetch("title_t", [])
    authors = fetch("author_name_t", [])
    
    case format
      when "book" 
        # Common
        reference_type = "BOOK"
        years = fetch("publication_year_t", [])
        start_page = "1"
        end_page =  fetch("publication_pages_t", ["1"]).first
        publishers = fetch("publication_publisher_t", [])
        serial_numbers = fetch("publication_newisbn_t", [])
        serial_numbers.concat fetch("publication_isbn_t", [])
        keywords = fetch("ctrlT_term_t", [])
        abstracts = fetch("abstract_abstract_t", [])
      when "article"
        # Common
        reference_type = "JOUR"
        years = fetch("journal_year_t", [])
        start_page = fetch("journal_page_t", ["1"]).first
        num_pages = fetch("journal_ppage_t", ["1"]).first.to_i
        end_page =  (start_page.to_i + num_pages - 1).to_s
        publishers = fetch("journal_publisher_t", [])
        serial_numbers = fetch("journal_issn_t", [])
        serial_numbers.concat fetch("journal_eissn_t", [])
        keywords = fetch("ctrlt_text_t", [])
        abstracts = fetch("abstract_text_t", [])
        
        # Specific to Journal Articles
        journal_full_titles = fetch("journal_title_t", [])
        journal_abbrev_titles = fetch("journal_atitle_t", [])
        journal_volumes = fetch("journal_vol_t", [])
        journal_issues = fetch("journal_issue_t", [])
      when "journal"
        # Common
        reference_type = "JFULL"
        years = []
        # start_page = []
        # end_page = []
        
        publishers = fetch("publisher_name_facet", [])
        serial_numbers = fetch("entry_issn_t", [])
        # serial_numbers.concat fetch("entry_eissn_t", [])
        keywords = fetch("keywords_facet", [])
        abstracts = fetch("entry_description_t", [])
      else
        years = fetch("journal_year_t", [])      
    end
    notes = fetch("note_note_t", [])
    publication_places = fetch("publication_location_t", [])
    dois = fetch("recordid_doi_t", [])
    
    
    export_text << "TY  - #{reference_type}\r\n"
    export_text << titles.map {|v| "T1  - #{v}\r\n" }.join
    export_text << authors.map {|v| "AU  - #{v}\r\n" }.join
    export_text << years.map {|v| "PY  - #{v}\r\n" }.join
    export_text << notes.map {|v| "N1  - #{v}\r\n" }.join
    export_text << keywords.map {|v| "KW  - #{v}\r\n" }.join
    unless format == "journal"
      export_text << "SP  - #{start_page}\r\n"
      export_text << "EP  - #{end_page}\r\n"
    end
    if format == "article"
      export_text << journal_full_titles.map {|v| "JF  - #{v}\r\n" }.join #JF
      export_text << journal_abbrev_titles.map {|v| "JA  - #{v}\r\n" }.join #JA
      export_text << journal_volumes.map {|v| "VL  - #{v}\r\n" }.join
      export_text << journal_issues.map {|v| "IS  - #{v}\r\n" }.join #IS
    end
    export_text << publishers.map {|v| "PB  - #{v}\r\n" }.join
    export_text << publication_places.map {|v| "CY  - #{v}\r\n" }.join
    export_text << serial_numbers.map {|v| "SN  - #{v}\r\n" }.join
    export_text << dois.map {|v| "DO  - #{v}\r\n" }.join
    export_text << abstracts.map {|v| "AB  - #{v}\r\n" }.join


    return export_text unless export_text.blank?
  end
  
end