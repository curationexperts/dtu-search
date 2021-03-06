# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController  

  include Blacklight::Catalog

  before_filter :clear_empty_format, :only=>:index

  shards = YAML.load_file(Rails.root + 'config/shards.yml')[Rails.env].map {|x|x.sub('http://', '')}

  configure_blacklight do |config|
    config.default_solr_params = { 
      :shards=> shards.join(','),
      :defType=>'edismax',
      :qt => 'search',
      :rows => 10 
    }

    # solr field configuration for search results/index views
    config.index.show_link = 'title_t' #'title_display'
    config.index.record_display_type = 'format'

    # solr field configuration for document/show views
    config.show.html_title = 'title_t'
    config.show.heading = 'title_t'
    config.show.display_type = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.    
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or 
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.  

    config.add_facet_field 'format', :label => 'Format', :limit => 20 
    config.add_facet_field 'journal_title_facet', :label => 'Journal Title', :limit => 20
    config.add_facet_field 'author_name_facet', :label => 'Author', :limit => 20 
#    config.add_facet_field 'keywords_facet', :label => 'Keywords', :limit => 20 
    config.add_facet_field 'pub_date', :label => 'Publication Year', :range => true



    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display 
    #config.add_index_field 'title_display', :label => 'Title:' 
    config.add_index_field 'article_title_t', :label => 'Article Title:' 
    config.add_index_field 'journal_title_t', :label => 'Journal Title:' 
    config.add_index_field 'author_name_t', :label => 'Author:' 

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display 
    #config.add_show_field 'title_display', :label => 'Title:' 
    config.add_show_field 'article_title_t', :label => 'Article Title:' 
    config.add_show_field 'journal_title_t', :label => 'Journal Title:' 
    config.add_show_field 'author_name_t', :label => 'Author:' 
    config.add_show_field 'abstract_text_t', :label => 'Abstract:' 

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different. 

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise. 
    
    config.add_search_field 'all_fields', :label => 'All Fields' do |field|
      field.solr_parameters = { :qf => 'title_t author_name_t abstract_text_t identifier_s keywords_facet' }
    end
    

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields. 
    
    config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params. 
      #field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = { 
        :qf => 'article_title_t',
        :pf => '$title_pf'
      }
    end
    
    config.add_search_field('author') do |field|
      #field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
      field.solr_local_parameters = { 
        :qf => 'author_name_t',
        :pf => 'author_name_t'
      }
    end
    
    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as 
    # config[:default_solr_parameters][:qt], so isn't actually neccesary. 
    config.add_search_field('subject') do |field|
      #field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
      field.qt = 'search'
      field.solr_local_parameters = { 
        :qf => '$subject_qf',
        :pf => '$subject_pf'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', :label => 'relevance'
    config.add_sort_field 'pub_date_sort desc, score desc, title_sort asc', :label => 'year'
    config.add_sort_field 'author_sort asc, title_sort asc', :label => 'author'
    config.add_sort_field 'title_sort asc, pub_date_sort desc', :label => 'title'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end


  def clear_empty_format
     params[:f].delete('format') if params[:f] && params[:f]['format'] == ['']
  end

  def transform_variable_names(solr_parameters, user_params)
    return if solr_parameters[:q].nil?
    start = solr_parameters[:q].dup
    start.gsub!(/\bauthor:/, 'author_name_t:')
    start.gsub!(/\btitle:/, 'title_t:')
    start.gsub!(/\bidentifier:/, 'identifier_s:')
    start.gsub!(/\bkeywords:/, 'ctrlt_text_t:')
    start.gsub!(/\bjournal:/, 'journal_title_t:')
    solr_parameters[:q] = start 
  end

  self.solr_search_params_logic << :transform_variable_names


end 
