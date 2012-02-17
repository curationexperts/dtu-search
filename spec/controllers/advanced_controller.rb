require 'spec_helper'

describe AdvancedController do

  describe "routes" do
    it "routes '/advanced' to the AdvancedController" do
      { :get => "/advanced" }.should route_to(:controller => "advanced")
    end
  end

end
