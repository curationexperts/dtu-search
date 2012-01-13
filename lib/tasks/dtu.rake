namespace :index do
  desc 'Index fixture objects in the repository.'
  task :all => [:articles, :journals, :books]

  desc "index article fixtures"
  task :articles => :environment do
    require 'buffered_indexer'
    require 'article_encoder'
    encoder = ArticleEncoder.new
    buff = BufferedIndexer.new
    Nokogiri::XML(File.open("spec/fixtures/records.txt")).root.xpath('/*/sf:art', {'sf'=>'http://schema.cvt.dk/art_oai_sf/2009'}).each do |l|
      buff.add(ArticleEncoder.solrize(l.to_xml))
    end
    buff.flush
    Blacklight.solr.commit
  end

  desc "index journal fixtures"
  task :journals => :environment do
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

  desc "index book fixtures"
  task :books => :environment do
  end
end
