require 'spec_helper'

describe AdvancedController do

  describe "routes" do
    it "routes '/advanced' to the AdvancedController" do
      { :get => "/advanced" }.should route_to(:controller => "advanced", :action=>'index')
    end
  end

  describe "#index" do
    describe "without parameters" do
      subject {get :index }
      it {should render_template('advanced/index')}
    end
    describe "with freetext" do
      subject {get :index, :q=>'rhizome', :title=>'', :author=>'', :year=>'' }
      it {should redirect_to catalog_index_path(:q=>'rhizome')}
    end
    describe "with title" do
      subject {get :index, :title=>'Nature', :q=>'', :author=>'', :year=>'' }
      it {should redirect_to catalog_index_path(:q=>'title:(Nature)')}
    end
    describe "with author" do
      subject {get :index, :author=>'Yeats', :title=>'', :q=>'', :year=>'' }
      it {should redirect_to catalog_index_path(:q=>'author:(Yeats)')}
    end
    describe "with year" do
      subject {get :index, :year=>'1970', :author=>'', :title=>'', :q=>'' }
      it {should redirect_to catalog_index_path(:q=>'year:(1970)')}
    end
    describe "with everything" do
      subject {get :index, :year=>'1970', :author=>'Yeats', :title=>'Nature', :q=>'rhizome' }
      it {should redirect_to catalog_index_path(:q=>'rhizome author:(Yeats) title:(Nature) year:(1970)')}
    end
  end

end
