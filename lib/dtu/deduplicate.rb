module DTU
  class Deduplicate
    # Based on the inf:member type attribute we prioritise the records.
    # 
    # 1. publisher (if more, the first record that appears)
    # 2. database (if more, the first record that appears)
    # 3. research
    # 4. aggregator (if more, the first record that appear)
    # 5. openaccess (if more, the first that appear)

    def initialize(shards)
      @shards = shards.map {|x|x.sub('http://', '')}
    end

    ## Search the database and return the best solr document with the given dedup key.
    def find_best(dedup_key)
      all_docs = Metastore.find_all_by_dedup(dedup_key).map do |m|
        DTU::ArticleEncoder.solrize(m.id, m.xml)
      end
      ranked = self.class.sort(all_docs)
      ranked.shift # return the first one
    end

    ## Search solr and return those documents that are duplicates (and can be discarded from the results)
    def find_duplicates(dedup_key)
      response = Blacklight.solr.select( :params=> {:shards=> @shards.join(','), :fl=>'id,localinfo_source_t,localinfo_dedupkey_t', :q=>"{!lucene}localinfo_dedupkey_t:#{dedup_key}"})
      all_docs = response["response"]["docs"]

      self.class.duplicates(all_docs)
    end

    def self.duplicates(all_docs)
      ranked = sort(all_docs)
      ranked.shift # keep the first one
      ranked
    end

    def self.sort(all_docs)
      all_docs.sort_by {|x| rank(x) }.reverse
    end

    def self.rank(doc)
        val = doc['localinfo_source_t']
        return 0 if val.nil?
        source = SOURCES[val.first.to_sym];
        source && source[:type] ? TYPE_RANK[source[:type]] + 100 - source[:rank] : 1 
    end

    TYPE_RANK = {
      publisher: 500,
      database: 400,
      research: 300,
      aggregator: 200,
      openaccess: 100 
    }


    SOURCES = {
      springer: {type: :publisher, rank: 1},
      swets: {type: :aggregator, rank: 2},
      isi: {type: :database, rank: 3},
      biosis: {type: :database, rank: 4},
      orbit: {type: :research, rank: 5},
      pubmed: {type: :database, rank: 6},
      degruyter: {type: :publisher, rank: 7},
      ebsco: {type: :aggregator, rank: 8},
      elsevier: {type: :publisher, rank: 9},
      acs: {type: :publisher, rank: 10},
      compendex: {type: :database, rank: 11},
      inspec: {type: :database, rank: 12},
      blackwell: {type: :publisher, rank: 13},
      ios: {type: :publisher, rank: 14},
      cell: {type: :publisher, rank: 15},
      wiley: {type: :publisher, rank: 16},
      highwire: {type: :aggregator, rank: 18},
      fsta: {type: :database, rank: 19},
      npg: {type: :publisher, rank: 20},
      karger: {type: :publisher, rank: 21},
      rsc: {type: :publisher, rank: 22},
      mal: {type: :publisher, rank: 23},
      sage: {type: :publisher, rank: 24},
      jstor: {type: :aggregator, rank: 25},
      cup: {type: :publisher, rank: 26},
      pnas: {type: :publisher, rank: 27},
      sciencemag: {type: :publisher, rank: 28},
      dlese: {type: :openaccess, rank: 29},
      doaj: {type: :openaccess, rank: 30},
      ecsprints: {type: :openaccess, rank: 31},
      emerald: {type: :publisher, rank: 32},
      iel: {type: :publisher, rank: 33},
      iop: {type: :publisher, rank: 34},
      orgprints: {type: :openaccess, rank: 35},
      spie: {type: :publisher, rank: 36},
      bmc: {type: :publisher, rank: 37},
      annualreviews: { rank: 38},
      arxiv: {type: :openaccess, rank: 39},
      cern: {type: :openaccess, rank: 40},
      dkart: {type: :aggregator, rank: 41},
      acm: {type: :publisher, rank: 42},
      nrc: {type: :publisher, rank: 43},
      intres: {type: :publisher, rank: 44},
      siam: {type: :publisher, rank: 45},
      bep: {type: :publisher, rank: 46},
      nasantrs: {type: :openaccess, rank: 47},
      biomed: {type: :publisher, rank: 48},
      scirp: {type: :publisher, rank: 49},
      caltech: {type: :openaccess, rank: 50},
      dlist: {type: :openaccess, rank: 51},
      euclid: {type: :openaccess, rank: 52},
      mathworld: {type: :openaccess, rank: 53},
      mitdspace: {type: :openaccess, rank: 54},
      numdam: {type: :openaccess, rank: 55},
      citeseer: {type: :openaccess, rank: 56}
    }
  end
end
