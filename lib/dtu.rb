module DTU
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :XmlEncoder
    autoload :JournalEncoder
    autoload :ArticleEncoder
    autoload :BookEncoder
    autoload :BufferedIndexer
    autoload :QueueWorker
    autoload :ShardedIndexer
  end
  

end
