class Metastore < ActiveRecord::Base
  self.primary_key = 'id' #required for jruby bug -- http://jira.codehaus.org/browse/JRUBY-6358
  self.table_name = 'public.metastore'

end
