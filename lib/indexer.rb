class Indexer
  extend ActiveSupport::Benchmarkable

  def self.run
    require 'buffered_indexer'
    require 'journal_encoder'
    encoder = JournalEncoder.new
    buff = BufferedIndexer.new
    count = 0
    Metastore.find_in_batches do |batch|
      count +=1
      puts "Batch ##{count}"
      benchmark "ingest 1000 documents" do
        batch.each do |l|
          buff.add(JournalEncoder.solrize(l.xml))
        end
      end
      break if (count == 100)
    end
    buff.flush
 end
  

end
