require 'spec_helper'

describe DTU::Deduplicate do
  #9837852
  describe "find_duplicates" do
    it "should return the duplicate fixtures" do
      dup = DTU::Deduplicate.new(YAML.load_file(Rails.root + 'config/shards.yml')[Rails.env])
      ### Keeping the compendex entry.
      dup.find_duplicates('9837852').should == [{"localinfo_source_t"=>["swets"],
         "localinfo_dedupkey_t"=>["9837852"], "id"=>"2004102797887465"},
        {"localinfo_source_t"=>["ebsco"], "localinfo_dedupkey_t"=>["9837852"], "id"=>"AFH:14577375"}]
    end
  end
  describe "ranking" do
    before do
      @database = { 'localinfo_source_t' => ['isi']}
      @research = { 'localinfo_source_t' => ['orbit']}
      @publisher = { 'localinfo_source_t' => ['degruyter']}
      @aggregator = { 'localinfo_source_t' => ['swets']}
      @openaccess = { 'localinfo_source_t' => ['dlese']}
      @empty = { 'localinfo_source_t' => ['annualreviews'] }
      @unknown = { 'localinfo_source_t' => ['invalid']}
      @notpresent = { }
    end
    it "should have ranks" do
      #actuall ranks aren't important, just their relative ranks.
      DTU::Deduplicate.rank(@publisher).should == 593
      DTU::Deduplicate.rank(@database).should == 497
      DTU::Deduplicate.rank(@research).should == 395
      DTU::Deduplicate.rank(@aggregator).should == 298
      DTU::Deduplicate.rank(@openaccess).should == 171
      DTU::Deduplicate.rank(@empty).should == 1
      DTU::Deduplicate.rank(@unknown).should == 1
      DTU::Deduplicate.rank(@notpresent).should == 0
    end
    it "should sort with high ranks first" do
      DTU::Deduplicate.sort([@openaccess, @research, @publisher, @database, @empty, @unknown, @notpresent, @aggregator]).should == [@publisher, @database, @research, @aggregator, @openaccess, @unknown, @empty, @notpresent]
    end

    it "should use the order of authority when there is a tie based on source" do
      @degruyter = { 'localinfo_source_t' => ['degruyter']}
      @springer = { 'localinfo_source_t' => ['springer']}
      @iop = { 'localinfo_source_t' => ['iop']}
      @spie = { 'localinfo_source_t' => ['spie']}
      DTU::Deduplicate.sort([@iop, @degruyter, @spie, @springer]).should == [@springer, @degruyter, @iop, @spie]
    end
  end
end
