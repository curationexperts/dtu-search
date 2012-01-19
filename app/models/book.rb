class Book
  cattr_accessor :fields

  @@fields = {'pub_date' => 'Year', 'publication_publisher_t' => 'Publisher', 'publication_isbn_t' =>'ISBN', 'publication_pages_t' => 'Pages', 'ebook_language_t' => 'Language', 'ctrlT_term_t' => 'Keywords'}

end
