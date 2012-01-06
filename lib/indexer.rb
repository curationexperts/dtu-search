class Indexer

  def self.run
    require 'buffered_indexer'
    require 'journal_encoder'
    file = File.join('spec', 'fixtures', 'records.txt')
    encoder = JournalEncoder.new
    buff = BufferedIndexer.new
    raise "File does not exist: #{file}" unless File.exist?(file)
    File.open(file).each do |l|
      buff.add(JournalEncoder.solrize(l))
    end
    buff.flush
 end
  

end
