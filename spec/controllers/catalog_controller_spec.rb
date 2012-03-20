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
    describe "with a year" do
      before {
        controller.params[:q] = "year:(1980)"
        @solr_params = controller.params
        @user_params = {:q=>controller.params[:q]}
      }
      it {
        controller.transform_variable_names(@solr_params, @user_params)
        @solr_params[:q].should == 'pub_date:(1980)'
        @user_params[:q].should == 'year:(1980)'
      }
    end
    
  end
end
