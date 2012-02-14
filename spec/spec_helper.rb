# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end


# a solr query method
# retrieve a solr document, given the doc id
def get_solr_response_for_doc_id(id=nil, extra_controller_params={})
  solr_response = force_to_utf8(Blacklight.solr.find solr_doc_params(id).merge(extra_controller_params))
  raise Blacklight::Exceptions::InvalidSolrID.new if solr_response.docs.empty?
  document = SolrDocument.new(solr_response.docs.first, solr_response)
  [solr_response, document]
end

# returns a params hash for finding a single solr document (CatalogController #show action)
# If the id arg is nil, then the value is fetched from params[:id]
# This method is primary called by the get_solr_response_for_doc_id method.
def solr_doc_params(id=nil)
  id ||= params[:id]
  # just to be consistent with the other solr param methods:
  {
    :qt => :document,
    :id => id # this assumes the document request handler will map the 'id' param to the unique key field
  }
end

def force_to_utf8(value)
  case value
  when Hash
    value.each { |k, v| value[k] = force_to_utf8(v) }
  when Array
    value.each { |v| force_to_utf8(v) }
  when String
    value.force_encoding("utf-8")  if value.respond_to?(:force_encoding) 
  end
  value
end