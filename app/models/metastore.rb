class Metastore < ActiveRecord::Base
  set_primary_key :id #required for jruby bug -- http://jira.codehaus.org/browse/JRUBY-6358
  set_table_name 'public.metastore'

end
