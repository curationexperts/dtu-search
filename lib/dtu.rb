module DTU
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :XmlEncoder
    autoload :JournalEncoder
    autoload :ArticleEncoder
    autoload :BookEncoder
    autoload :BufferedIndexer
    autoload :Deduplicate
    autoload :QueueIndexWorker
    autoload :QueueDedupWorker
    autoload :ShardedIndexer
    autoload :DocumentExtensions
  end
  

end
