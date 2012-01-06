require 'spec_helper'
require 'indexer'

describe Indexer do
  it "should run well" do
    Indexer.run.should be_true
  end

end
