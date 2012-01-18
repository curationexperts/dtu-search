module DTU
  class XmlEncoder
    def self.solrize(id, xml)
      o = {}
      doc = Nokogiri::XML(xml)

      o = hashify(doc.root.children)
      identifier(id, o)
      o
    end

    # Turns a Nokogiri node set into a hash. This will only work with very simple xml documents
    def self.hashify(node_set)
      o = {}
      node_set.xpath('//*[not(*)]').each do |node|
        name = (node.ancestors.map{ |n| n.name}[0..-3].reverse + [node.name, 't']).join("_") 
        val =  node.inner_text
        if o.has_key? name
          o[name] << val 
        else
          o[name] = [val]
        end
      end
      o
    end

    def self.pub_date(key, doc)
      if year = doc[key]
        if matchdata = /^(\d{4})/.match(year.first)
          doc['pub_date'] = matchdata[1]
        end
      end
    end
  end
end
