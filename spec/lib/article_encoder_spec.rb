require 'spec_helper'

require 'article_encoder'

describe ArticleEncoder do

  describe "add"  do
    it "should work" do
      doc = ArticleEncoder.solrize(File.open("spec/fixtures/first_article.xml"))
      doc['format'].should == 'article'
      doc['id'].should == '2004102797887465'
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
      result = ArticleEncoder.hashify(ns.root.children)
      result['author_name_t'].should == ['El-Fadel, Mutasem', 'Aldeen, Raja Abou Fakher', 'Maroun, Rania']
    end
  end
end
