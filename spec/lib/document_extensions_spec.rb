# encoding: utf-8
require 'spec_helper'

describe DTU::DocumentExtensions do
  
  before do
    @book_response, @book_document = get_solr_response_for_doc_id("ocn707192288")
    @article_response, @article_document = get_solr_response_for_doc_id("PUI39123500")
    @journal_response, @journal_document = get_solr_response_for_doc_id("00000191")
  end
  
  describe "export_as_refworks" do
    it "should export books" do 
      expected = "RT  - Book, Whole\nT1  - A scenario tree-based decomposition for solving multistage stochastic programs : with application in energy production\nA1  - Mahlke, Debora.\nY1  - 2011\nN1  - Series: Vieweg+Teubner research. Stochastic programming\nN1  - Diss.-- Technische Universität Darmstadt, 2010.\nN1  - Includes bibliographical references.\nKW  - Electronic books.\nKW  - Stochastic programming.\nSP  - 1\nEP  - xvi, 182 p\nPB  - Vieweg+Teubner Verlag\nPP  - Wiesbaden\nSN  - 9783834898296\nSN  - 9783834814098\nSN  - 3834898295\nSN  - 3834814091\n"
      @book_document.export_as_refworks.should == expected
    end
    it "should export journal articles" do 
      expected = "RT  - Journal Article\nT1  - Impact of diesel policy banning on PM levels in urban areas\nA1  - El-Fadel, Mutasem\nA1  - Aldeen, Raja Abou Fakher\nA1  - Maroun, Rania\nY1  - 2004\nKW  - Air pollution control\nKW  - Air quality\nKW  - Diesel engines\nKW  - Economic and social effects\nKW  - Health hazards\nKW  - Public policy\nKW  - Environmental protection\nKW  - T\nKW  - X\nSP  - 427-436\nEP  - 427\nJF  - International Journal of Environmental Studies\nJA  - Int. J. Environ. Stud.\nJA  - The International journal of environmental studies\nVO  - 61\nIS  - 4\nPB  - Taylor and Francis Ltd.\nSN  - 00207233\nSN  - 10290400\nM3  - 10.1080/0020723042000189886\nN2  - Increased use of diesel engine in on-road vehicles presents a serious health concern, particularly in traffic-congested urban areas. Diesel exhaust contains various gaseous and particulate pollutants, which, at high concentrations, pose adverse health effects. In this respect, various policy measures are being adopted worldwide to curtail emissions from diesel engines. This paper presents an assessment of diesel engine policy banning in the Greater Beirut Area. For this purpose, particulate matter levels in the air were measured after the ban and compared with concentrations reported prior to the ban. Health-based socio-economic benefits associated with improvement in air quality were then estimated using the long-term decrease of particulate matter as an indicator.\n"
      @article_document.export_as_refworks.should == expected
    end
    it "should export journal articles" do 
      expected = "RT  - Journal, Electronic\nT1  - WHO'S WHO IN AMERICAN ART.\nKW  - THE ARTS \nKW  -  ART AND ART HISTORY\nPB  - RR Bowker\nSN  - 0000-0191\nN2  - Over 11,800 entries, the guide's concise listings detail entrants' date and place of birth, education and training, commissions, exhibitions, professional positions, and awards (all dated by year); museums holding their work; books and articles by and about them; the media they work in; and their dealer or representative and mailing address.\n"
      @journal_document.export_as_refworks.should == expected
    end
  end
  
end