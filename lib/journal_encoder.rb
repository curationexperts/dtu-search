class JournalEncoder
  include Solrizer::XML::TerminologyBasedSolrizer

  def self.solrize(xml)
    o = {}
    doc = Nokogiri::XML(xml)
    o = flatten(hashify(doc.root.children))
    types(o)
    identifier(o)
#    puts o.inspect
    o
  end

  def self.identifier(doc)
    doc['id'] = doc['localinfo_key_t']
    doc['journal_title_facet'] = doc['journal_title_t']
    doc['article_title_s'] = doc['article_title_t']
  end

  def self.types(doc)
    doc.keys.each do |key|
      val = doc.delete(key)
      doc[key +'_t'] = val
    end
  end

  
  # Turns a Nokogiri node set into a hash. This will only work with very simple xml documents
  def self.hashify(node_set)
    o = {}
    node_set.each do |node|
      o[node.name] = node.element_children.empty? ? node.inner_text : hashify(node.element_children) 
    end
    o
  end

  # make a one level hash out of a tree, concatinate the keys together with underscore
  # {'x' => {'y' => 'z', q=>'k'}}
  # {'x_y' => 'z', 'x_q' => 'k'}
  def self.flatten(tree)
    o = {}
    tree.each do |key, val|
      if val.is_a?(Hash)
        val.each do |k, v|
          o["#{key}_#{k}"] = v
        end
      end
    end
#    puts o.inspect + "\n\n"
    o
  end

end
