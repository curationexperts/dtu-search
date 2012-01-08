class BufferedIndexer 
  BUFFER_SIZE=1000
  COMMIT_EVERY =10



  def initialize
    @count = 0
    @batch_count = 0
    @docs = []
  end

  def flush(commit = false)
    solr.add @docs
    @docs = []
    @count = 0
    @batch_count += 1
    if commit || @batch_count > COMMIT_EVERY
      solr.commit
      @batch_count =0
    end
  end

  def add(doc)
    @docs << doc
    increment
  end

  private

  def increment
    @count += 1
    flush if @count >= BUFFER_SIZE
  end

  def solr
    Blacklight.solr
  end
end
