# encoding: utf-8
require 'spec_helper'

describe DTU::DocumentExtensions do
  
  before do
    @book_response, @book_document = get_solr_response_for_doc_id("ocn707192288")
    @article_response, @article_document = get_solr_response_for_doc_id("PUI39123500")
    @journal_response, @journal_document = get_solr_response_for_doc_id("00000191")
  end
  
  describe "export_as_ris" do
    it "should export books" do 
      expected = "TY  - BOOK\r\nT1  - A scenario tree-based decomposition for solving multistage stochastic programs : with application in energy production\r\nAU  - Mahlke, Debora.\r\nPY  - 2011\r\nN1  - Series: Vieweg+Teubner research. Stochastic programming\r\nN1  - Diss.-- Technische Universität Darmstadt, 2010.\r\nN1  - Includes bibliographical references.\r\nKW  - Electronic books.\r\nKW  - Stochastic programming.\r\nSP  - 1\r\nEP  - xvi, 182 p\r\nPB  - Vieweg+Teubner Verlag\r\nCY  - Wiesbaden\r\nSN  - 9783834898296\r\nSN  - 9783834814098\r\nSN  - 3834898295\r\nSN  - 3834814091\r\n"
      @book_document.export_as_ris.should == expected
    end
    it "should export journal articles" do 
      expected = "TY  - JOUR\r\nT1  - Impact of diesel policy banning on PM levels in urban areas\r\nAU  - El-Fadel, Mutasem\r\nAU  - Aldeen, Raja Abou Fakher\r\nAU  - Maroun, Rania\r\nPY  - 2004\r\nKW  - Air pollution control\r\nKW  - Air quality\r\nKW  - Diesel engines\r\nKW  - Economic and social effects\r\nKW  - Health hazards\r\nKW  - Public policy\r\nKW  - Environmental protection\r\nKW  - T\r\nKW  - X\r\nSP  - 427-436\r\nEP  - 427\r\nJF  - International Journal of Environmental Studies\r\nJA  - Int. J. Environ. Stud.\r\nJA  - The International journal of environmental studies\r\nVL  - 61\r\nIS  - 4\r\nPB  - Taylor and Francis Ltd.\r\nSN  - 00207233\r\nSN  - 10290400\r\nDO  - 10.1080/0020723042000189886\r\nAB  - Increased use of diesel engine in on-road vehicles presents a serious health concern, particularly in traffic-congested urban areas. Diesel exhaust contains various gaseous and particulate pollutants, which, at high concentrations, pose adverse health effects. In this respect, various policy measures are being adopted worldwide to curtail emissions from diesel engines. This paper presents an assessment of diesel engine policy banning in the Greater Beirut Area. For this purpose, particulate matter levels in the air were measured after the ban and compared with concentrations reported prior to the ban. Health-based socio-economic benefits associated with improvement in air quality were then estimated using the long-term decrease of particulate matter as an indicator.\r\n"
      @article_document.export_as_ris.should == expected
    end
    it "should export journal articles" do 
      expected = "TY  - JFULL\r\nT1  - WHO'S WHO IN AMERICAN ART.\r\nKW  - THE ARTS \r\nKW  -  ART AND ART HISTORY\r\nPB  - RR Bowker\r\nSN  - 0000-0191\r\nAB  - Over 11,800 entries, the guide's concise listings detail entrants' date and place of birth, education and training, commissions, exhibitions, professional positions, and awards (all dated by year); museums holding their work; books and articles by and about them; the media they work in; and their dealer or representative and mailing address.\r\n"
      @journal_document.export_as_ris.should == expected
    end
  end
  
end