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
      subject {get :index, :q=>'rhizome', :title=>'', :author=>'', :keywords=>'' }
      it {should redirect_to catalog_index_path(:q=>'rhizome')}
    end
    describe "with title" do
      subject {get :index, :title=>'All about science', :q=>'', :author=>'', :keywords=>'' }
      it {should redirect_to catalog_index_path(:q=>'title:(All about science)')}
    end
    describe "with author" do
      subject {get :index, :author=>'Yeats', :title=>'', :q=>'', :keywords=>'' }
      it {should redirect_to catalog_index_path(:q=>'author:(Yeats)')}
    end
    describe "with identifier" do
      subject {get :index, :identifier=>'12345-123', :author=>'', :title=>'', :q=>'' }
      it {should redirect_to catalog_index_path(:q=>'identifier:(12345-123)')}
    end
    describe "with keywords" do
      subject {get :index, :keywords=>'frog amphibian', :author=>'', :title=>'', :q=>'' }
      it {should redirect_to catalog_index_path(:q=>'keywords:(frog amphibian)')}
    end
    describe "with journal title" do
      subject {get :index, :journal=>'Nature', :author=>'', :title=>'', :q=>'' }
      it {should redirect_to catalog_index_path(:q=>'journal:(Nature)')}
    end
    describe "with multiple fields" do
      subject {get :index, :author=>'Yeats', :title=>'Nature', :q=>'rhizome' }
      it {should redirect_to catalog_index_path(:q=>'rhizome author:(Yeats) title:(Nature)')}
    end
    describe "with type" do
      subject {get :index, :journal=>'Nature', :f=>{:format=>['journal']}, :author=>'', :title=>'', :q=>'' }
      it {should redirect_to catalog_index_path(:q=>'journal:(Nature)', :f=>{:format=>['journal']})}
    end
    describe "with year" do
      subject {get :index, :range=>{:pubdate=>{:begin=>'1970', :end=>'1980'}}, :author=>'', :title=>'', :q=>'' }
      it {should redirect_to catalog_index_path(:q=>'', :range=>{:pubdate=>{:begin=>'1970', :end=>'1980'}})}
    end
  end

end
