class BufferedIndexer 
  BUFFER_SIZE=1000



  def initialize
    @count = 0
    @docs = []
  end

  def flush
    solr.add @docs
    solr.commit
    @docs = []
    @count = 0
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
