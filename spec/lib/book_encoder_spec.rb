require 'spec_helper'

describe DTU::BookEncoder do

  describe "add"  do
    it "should work" do
      doc = DTU::BookEncoder.solrize('book_fixture', File.open("spec/fixtures/first_book.xml"))
      doc['format'].should == 'book'
      doc['id'].should == '0032316769777'
      doc['title_t'].should == ['Rfid sourcebook [electronic resource] /']
      doc['author_name_t'].should == ['Lahiri, Sandip.', 'Safari Tech Books Online.']
      doc['title_sort'].should == 'Rfid sourcebook [electronic resource] /'
      doc['author_sort'].should == 'Lahiri, Sandip.'
      doc['pub_date'].should == '2013'
      doc['identifier_s'].should == ["0131851373", "0032316769777"]
      doc['keywords_facet'].should == ['RFID', 'Radio frequency']
      doc['abstract_text_t'].should == ['Lorem Ipsum sit ament dolorum.']
    end
  end
end

