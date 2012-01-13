module DTU
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :XmlEncoder
    autoload :JournalEncoder
    autoload :ArticleEncoder
    autoload :BufferedIndexer
  end
  

end
