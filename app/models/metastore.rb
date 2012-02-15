class Metastore < ActiveRecord::Base
  primary_key = 'id' #required for jruby bug -- http://jira.codehaus.org/browse/JRUBY-6358
  table_name = 'public.metastore'

end
