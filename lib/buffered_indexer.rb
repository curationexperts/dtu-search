class BufferedIndexer 
  BUFFER_SIZE=1000

  def initialize
    @count = 0
  end

  def flush
    solr.commit
    @count = 0
  end

  def add(doc)
    solr.add doc
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
