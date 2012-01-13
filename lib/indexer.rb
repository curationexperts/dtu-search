class Indexer
  extend ActiveSupport::Benchmarkable

  BATCH_SIZE = 1000

  def self.run(num)
    require 'buffered_indexer'
    require 'artical_encoder'
    encoder = ArticleEncoder.new
    buff = BufferedIndexer.new
    count = 0

    num_batches = (num / BATCH_SIZE).to_i
    
    Metastore.find_in_batches do |batch|
      count +=1
      puts "Batch ##{count}"
      benchmark "ingest 1000 documents" do
        batch.each do |l|
          buff.add(ArticleEncoder.solrize(l.xml))
        end
      end
      break if (count == num_batches)
    end
    buff.flush
 end
  

end
