require 'spec_helper'

describe DTU::JournalEncoder do

  describe "add"  do
    it "should work" do
      doc = DTU::JournalEncoder.solrize('journal_fixture', File.open("spec/fixtures/first_journal.xml"))
      doc['format'].should == 'journal'
      doc['id'].should == '00014826'
      doc['entry_holdings_interval_from_year_t'].should == ["1926", "1999", "1926"]
      doc['publisher_name_facet'].should == 'American Accounting Association'
      doc['title_t'].should == ["The Accounting review"]
      doc['title_sort'].should == 'The Accounting review'
      doc['entry_issn-normalized_t'].should == ["00014826", "00014826", "00014826", "00014826", "15587967"]
      doc['identifier_s'].should == ["0001-4826", "00014826", "1558-7967", "15587967"]
      doc['keywords_facet'].should == ["BUSINESS AND ECONOMICS ", "Business, Economy and Management", " ACCOUNTING", "Accounting and Auditing", "Business Management", "Finance", "General and Others", "Trade and Commerce"]
    end
  end
end

