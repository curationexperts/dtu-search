require 'spec_helper'

describe "AdvancedSearches" do
  describe "GET /advanced" do
    it "should have a form" do
      visit advanced_searches_path
      page.should have_selector("form[action='#{advanced_search_path}']")
      page.should have_selector("input[type=hidden][name=search_field][value=all_fields]")
    end
  end
end
