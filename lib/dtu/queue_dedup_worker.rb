module DTU
  class QueueDedupWorker
    def initialize(name = 'search.dedup')
      @queue_name = name
      @buff = DTU::ShardedIndexer.new
      @dup_finder = DTU::Deduplicate.new(@buff.shards)
      @stopped = false
    end

    def stop
      puts "finishing writes"
      @stopped=true
    end


    # setting up queue must happen in same thread as run()
    def setup_queue
      Thread.current[:carrot] = Carrot.new(:host=>'mediashelf1.dtic.dk')
      @q = Carrot.queue(@queue_name)
    end

    def run
      setup_queue
      while !@stopped && msg = @q.pop
        begin
          @buff.add @dup_finder.find_best(msg)
        rescue RSolr::Error::Http, Errno::ECONNREFUSED => exception
          puts "Fatal #{exception.class}, exception see log"
          logger.fatal( "\n\n#{exception.class} (#{exception.message})\n\n")
          logger.flush
          exit!
        rescue StandardError => exception
          puts "Caught #{exception.class}, see log"
          logger.fatal( "\n\n#{exception.class} (#{exception.message}):\n    " + exception.backtrace.join("\n    ") + "\n\n")
          logger.flush
        end
      end
      puts "flushing buffers"
      @buff.flush(true)
      Carrot.stop
      puts "done"
    end
  end
end
