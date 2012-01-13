class ArticleEncoder

  def self.solrize(xml)
    o = {}
    doc = Nokogiri::XML(xml)

    o = hashify(doc.root.children)
    identifier(o)
    #puts o.inspect
    o
  end

  def self.identifier(doc)
    doc['id'] = doc['localinfo_key_t'].first
    doc['format'] = 'article'
    if doc['journal_title_t'].nil?
      raise "No Journal title for article #{doc['id']}"
    end
    doc['journal_title_facet'] = doc['journal_title_t'].first
    doc['author_name_facet'] = doc['author_name_t']
    doc['article_title_s'] = doc['article_title_t'].first
  end

  # Turns a Nokogiri node set into a hash. This will only work with very simple xml documents
  def self.hashify(node_set)
    o = {}
    node_set.xpath('/*/*/*/text()').each do |node|
      name = node.parent.parent.name + '_' + node.parent.name + '_t'
      val =  node.inner_text
      if o.has_key? name
        o[name] << val 
      else
        o[name] = [val]
      end
    end
    o
  end

end
