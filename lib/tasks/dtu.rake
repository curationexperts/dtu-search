
desc 'Index fixture objects in the repository.'
task :solrize_fixtures => :environment do
    require 'buffered_indexer'
    require 'journal_encoder'
    encoder = JournalEncoder.new
    buff = BufferedIndexer.new
    File.open("spec/fixtures/records.txt").each do |l|
      buff.add(JournalEncoder.solrize(l))
    end
    buff.flush
  
end  
