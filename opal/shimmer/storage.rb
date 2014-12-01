module Shimmer
	class Storage
	  def initialize(config_object)
	    @config_object = config_object
	    @storage_path = config_object.generate_key_path
	    @include_keys = Set.new
	  end
	  
	  def load_value(key)
	    json_value = `window.localStorage[#{@storage_path + '.' + key}]`
	    if `json_value != null`
  	    JSON.parse(json_value)
  	  else
  	    nil
  	  end
	  end
	
	  def save_value(key, value)
	    `window.localStorage[#{@storage_path + '.' + key}] = #{JSON.dump(value)}`
	  end
	  
	  def should_include?(key)
	    @include_keys.include?(key)
	  end
	  def should_include(key)
	    @include_keys << key
	  end
	  
	  def include?(key)
	    `window.localStorage[#{@storage_path + '.' + key}] != null`
	  end
	end
end