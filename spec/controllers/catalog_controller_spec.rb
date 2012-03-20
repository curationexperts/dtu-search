require 'spec_helper'

describe CatalogController do
  describe "the controller" do
    subject { CatalogController}
    its(:solr_search_params_logic){ should include(:transform_variable_names)}
  end
  
  
  describe "#transform_variable_names" do
    describe "with nil" do
      before {
        controller.params[:q] = "author:(Lee)"
        @solr_params = {}
        @user_params = {}
      }
      it {
        controller.transform_variable_names({}, {})
        @solr_params[:q].should be_nil 
        @user_params[:q].should be_nil
      }
    end
    describe "with an author" do
      before {
        controller.params[:q] = "author:(Lee)"
        @solr_params = controller.params
        @user_params = {:q=>controller.params[:q]}
      }
      it {
        controller.transform_variable_names(@solr_params, @user_params)
        @solr_params[:q].should == 'author_name_t:(Lee)'
        @user_params[:q].should == 'author:(Lee)'
      }
    end
    
    describe "with a title" do
      before {
        controller.params[:q] = "title:(Nature)"
        @solr_params = controller.params
        @user_params = {:q=>controller.params[:q]}
      }
      it {
        controller.transform_variable_names(@solr_params, @user_params)
        @solr_params[:q].should == 'title_t:(Nature)'
        @user_params[:q].should == 'title:(Nature)'
      }
    end
    describe "with a journal title" do
      before {
        controller.params[:q] = "journal:(Nature)"
        @solr_params = controller.params
        @user_params = {:q=>controller.params[:q]}
      }
      it {
        controller.transform_variable_names(@solr_params, @user_params)
        @solr_params[:q].should == 'journal_title_t:(Nature)'
        @user_params[:q].should == 'journal:(Nature)'
      }
    end
    describe "with an identifier" do
      before {
        controller.params[:q] = "identifier:(1234-123)"
        @solr_params = controller.params
        @user_params = {:q=>controller.params[:q]}
      }
      it {
        controller.transform_variable_names(@solr_params, @user_params)
        @solr_params[:q].should == 'identifier_s:(1234-123)'
        @user_params[:q].should == 'identifier:(1234-123)'
      }
    end
    describe "with keywords" do
      before {
        controller.params[:q] = "keywords:(turtle)"
        @solr_params = controller.params
        @user_params = {:q=>controller.params[:q]}
      }
      it {
        controller.transform_variable_names(@solr_params, @user_params)
        @solr_params[:q].should == 'ctrlt_text_t:(turtle)'
        @user_params[:q].should == 'keywords:(turtle)'
      }
    end
    
  end
end
