Rails.configuration.sass.tap do |config|
  if Rails.env.development? || Rails.env.test?
	  require 'compass'
	  config.load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"  
  end
end
