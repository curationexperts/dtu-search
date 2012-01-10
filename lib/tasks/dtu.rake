
desc 'Index fixture objects in the repository.'
task :solrize_fixtures => :environment do
    require 'buffered_indexer'
    require 'journal_encoder'
    encoder = JournalEncoder.new
    buff = BufferedIndexer.new
    Nokogiri::XML(File.open("spec/fixtures/records.txt")).root.xpath('/*/sf:art', {'sf'=>'http://schema.cvt.dk/art_oai_sf/2009'}).each do |l|
      buff.add(JournalEncoder.solrize(l.to_xml))
    end
    buff.flush
    Blacklight.solr.commit
  
end  
