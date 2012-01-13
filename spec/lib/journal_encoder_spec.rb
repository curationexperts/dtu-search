require 'spec_helper'

describe DTU::JournalEncoder do

  describe "add"  do
    it "should work" do
      doc = DTU::JournalEncoder.solrize(File.open("spec/fixtures/first_journal.xml"))
      doc['format'].should == 'journal'
      doc['id'].should == '00000043'
      doc['entry_holdings_interval_from_year_t'].should == ['1967']
      doc['journal_title_facet'].should == 'Irregular serials + annuals'
      doc['publisher_name_facet'].should == 'Bowker'
      doc['title_s'].should == 'Irregular serials + annuals'
    end
  end
end

