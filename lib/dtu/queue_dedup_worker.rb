module DTU
  class QueueDedupWorker
    SELECT_SIZE = 1000

    def initialize
      Thread.current[:carrot] = Carrot.new(:host=>'mediashelf1.dtic.dk')
      @q = Carrot.queue('search.dedup')

      @buff = DTU::ShardedIndexer.new
      @dup_finder = DTU::Deduplicate.new(@buff.shards)
      @stopped = false
    end

    def stop
      puts "finishing writes"
      @stopped=true
    end

    def run
      while !@stopped && msg = @q.pop
        list = [msg]
        SELECT_SIZE.times do
          list << @q.pop
        end
        l = Metastore.find(list)
        l.each do |m|
          begin
            @dup_finder.find_duplicates(m['dedup']).each do |duplicate|
              @buff.delete(duplicate)
            end
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
      end
      puts "flushing bufferes"
      @buff.flush(true)
      Carrot.stop
      puts "done"
    end
  end
end
