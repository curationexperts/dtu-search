require 'spec_helper'

describe DTU::BookEncoder do

  describe "add"  do
    it "should work" do
      doc = DTU::BookEncoder.solrize('book_fixture', File.open("spec/fixtures/first_book.xml"))
      doc['format'].should == 'book'
      doc['id'].should == '0032316769777'
      doc['title_t'].should == ['Rfid sourcebook [electronic resource] /']
      doc['author_name_t'].should == ['Lahiri, Sandip.', 'Safari Tech Books Online.']
    end
  end
end

