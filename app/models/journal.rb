class Journal
  cattr_accessor :fields

  @@fields = {'entry_issn_t' => 'ISSN', 'entry_publisher_name_t' => 'Publisher', 'publication_isbn_t' =>'ISBN', 'publication_pages_t' => 'Pages', 'ebook_language_t' => 'Language', 'ctrlT_term_t' => 'Keywords'}
end
