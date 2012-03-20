require 'spec_helper'

describe "AdvancedSearches" do
  describe "GET /advanced" do
    it "should have a form" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit advanced_searches_path
      page.should have_selector("form[action='#{advanced_search_path}']")
    end
  end
end
