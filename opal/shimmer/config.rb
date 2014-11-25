module Shimmer

	class Config
	  def initialize(parent_level=nil)
	    @parent_level = parent_level
	    @store = {}
	  end
	
	  def method_missing(method_name, *args, &block)
#	    puts method_name
	    if method_name.to_s[-1] == "="
	      @store[method_name.to_s[0..-2]] = args[0]
	    else
	      if @store.has_key?(method_name.to_s)
	        @store[method_name.to_s]
	      else
	        @store[method_name.to_s] = self.class.new(self)
	      end
	    end
	  end
	  
	  def include?(key)
	    @store.include?(key)
	  end
	  
	  def nil?
	    @store.length == 0
	  end
	  
	  def to_s
	    if @store.length == 0
	      ""
	    else
	      @store.inspect
	    end
	  end
	  
	  def to_i
	    0
	  end
	  
	  def to_bool
	    false
	  end
	  
	  def to_h
	    @store
	  end
	end

end