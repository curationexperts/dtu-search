module DTU
  class QueueWorker
    SELECT_SIZE = 1000

    def initialize
      Thread.current[:carrot] = Carrot.new(:host=>'mediashelf1.dtic.dk')
      @q = Carrot.queue('search.index')

      @buff = DTU::ShardedIndexer.new
      at_exit { shutdown_cleanly} 
      # Signal.trap("INT") { shutdown_cleanly }
      # Signal.trap("TERM") { shutdown_cleanly }
      # Signal.trap("KILL") { shutdown_cleanly }
    end

    def shutdown_cleanly
      print "Finishing writes..."
      @buff.flush()
      puts "Done."
     # Thread.exit
    end


    def run
      while msg = @q.pop
        list = [msg]
        SELECT_SIZE.times do
          list << @q.pop
        end
        l = Metastore.find(list)
        l.each do |m|
          begin
            doc = DTU::ArticleEncoder.solrize(m.id, m.xml)
            @buff.add(doc)
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
      @buff.flush(true)
      Carrot.stop
    end
  end
end
