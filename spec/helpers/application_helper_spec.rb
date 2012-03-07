require 'spec_helper'

describe ApplicationHelper do
  describe "link_to_recommendations"  do
    it "should default to generating sfx links" do
      doc = DTU::ArticleEncoder.solrize('article_without_fulltext', File.open("spec/fixtures/first_article.xml"))
      recommendation_url = helper.link_to_recommendations(doc)
      CGI.unescape(recommendation_url).should == "http://digitallibrary.dtu.dk/BXProxy/recommend?rft.jtitle=Short-term effects of planktonic rotifers and cladocerans on phytoplankton of the River Nile&amp;rft.issn=00207233&amp;rft.pages=403&amp;rft.spage=403&amp;rft.volume=61&amp;rft.issue=4&amp;rft.date=2004-2008&amp;rft.atitle=Short-term effects of planktonic rotifers and cladocerans on phytoplankton of the River Nile&amp;rft.doi=&amp;rft.au=Khalifa, Nehad&amp;rfr_id=info:sid/dlib.dtu.dk:DTUDigitalLibrary"
    end
  end

  describe "link_to_fulltext"  do
    it "should default to generating sfx links" do
      doc = DTU::ArticleEncoder.solrize('article_without_fulltext', File.open("spec/fixtures/first_article.xml"))
      fulltext_url = helper.link_to_fulltext(doc)
      CGI.unescape(fulltext_url).should == "http://sfx.cvt.dk/sfx_local?rft.jtitle=Short-term effects of planktonic rotifers and cladocerans on phytoplankton of the River Nile&amp;rft.issn=00207233&amp;rft.pages=403&amp;rft.spage=403&amp;rft.volume=61&amp;rft.issue=4&amp;rft.date=2004-2008&amp;rft.atitle=Short-term effects of planktonic rotifers and cladocerans on phytoplankton of the River Nile&amp;rft.doi=&amp;rft.au=Khalifa, Nehad&amp;rfr_id=info:sid/dlib.dtu.dk:DTUDigitalLibrary"
    end
    it "should generate local urls if info for local fulltext is available" do
      doc = DTU::ArticleEncoder.solrize('article_with_fulltext', File.open("spec/fixtures/article_with_fulltext.xml"))
      fulltext_url = helper.link_to_fulltext(doc) 
      CGI.unescape(fulltext_url).should == "http://redirect.cvt.dk?url=http://dtu-ftc.cvt.dk/cgi-bin/fulltext/elsevier?pi=/0017/9310/00520013/09000763.pdf&key=130140113&rfr_id=info:sid/dlib.dtu.dk:DTUDigitalLibraryBlacklight"
    end
  end
end

