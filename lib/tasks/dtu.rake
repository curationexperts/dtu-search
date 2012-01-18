require 'dtu'
desc "Index all fixtures"
task :index => 'index:all'

namespace :index do
  desc 'Index fixture objects in the repository.'
  task :all => [:articles, :journals, :books]

  desc "index article fixtures"
  task :articles => :environment do
    buff = DTU::BufferedIndexer.new
    Nokogiri::XML(File.open("spec/fixtures/records.txt")).root.xpath('/*/sf:art', {'sf'=>'http://schema.cvt.dk/art_oai_sf/2009'}).each do |l|
      buff.add(DTU::ArticleEncoder.solrize('article_fixture', l.to_xml))
    end
    buff.flush
    Blacklight.solr.commit
  end

  desc "index journal fixtures"
  task :journals => :environment do
    buff = DTU::BufferedIndexer.new
    Nokogiri::XML(File.open("spec/fixtures/journal.xml")).root.xpath('/documents/document').each do |l|
      buff.add(DTU::JournalEncoder.solrize('journal_fixture', l.to_xml))
    end
    buff.flush
    Blacklight.solr.commit
  end

  desc "index book fixtures"
  task :books => :environment do
    buff = DTU::BufferedIndexer.new
    Nokogiri::XML(File.open("spec/fixtures/book.xml")).root.xpath('/documents/ebk').each do |l|
      buff.add(DTU::BookEncoder.solrize('book_fixture', l.to_xml))
    end
    buff.flush
    Blacklight.solr.commit
  end
end
