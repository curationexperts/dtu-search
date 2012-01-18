require 'spec_helper'

describe DTU::ArticleEncoder do

  describe "add"  do
    it "should work" do
      doc = DTU::ArticleEncoder.solrize('article_fixture', File.open("spec/fixtures/first_article.xml"))
      doc['format'].should == 'article'
      doc['id'].should == '2004102797887465'
      doc['title_t'].should == ['Short-term effects of planktonic rotifers and cladocerans on phytoplankton of the River Nile']
      doc['title_sort'].should == 'Short-term effects of planktonic rotifers and cladocerans on phytoplankton of the River Nile'
      doc['author_sort'].should == 'Khalifa, Nehad'
      doc['keywords_facet'].should == ['Plankton', 'Rotifers']
      doc['pub_date'].should == '2004'
    end
  end
  describe "#hashify" do
    it "should allow multivalues" do
      ns = Nokogiri::XML.parse("<people>
          <sf:author>
            <sf:name>El-Fadel, Mutasem</sf:name>
          </sf:author>
          <sf:author>
            <sf:name>Aldeen, Raja Abou Fakher</sf:name>
          </sf:author>
          <sf:author>
            <sf:name>Maroun, Rania</sf:name>
          </sf:author>
      </people>") 
      result = DTU::ArticleEncoder.hashify(ns.root.children)
      result['author_name_t'].should == ['El-Fadel, Mutasem', 'Aldeen, Raja Abou Fakher', 'Maroun, Rania']
    end
  end
end
