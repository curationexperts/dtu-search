module DTU
  class ShardedIndexer
    
    def initialize
      shards = YAML.load_file(Rails.root + 'config/shards.yml')[Rails.env]
      @buffers = []
      shards.each do |conf|
        @buffers << DTU::BufferedIndexer.new(RSolr.connect(:url=>conf))
      end
    end

    def add(doc)
      buffer(doc['id']).add(doc)
    end

    def flush(commit = false)
      @buffers.each {|b| b.flush(commit)}
    end

    def buffer(id)
      raise "No id" unless id
      n = Digest::MD5.hexdigest(id.to_s).hex % @buffers.count
      @buffers[n]
    end

  end
end

