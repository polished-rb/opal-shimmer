module Shimmer

	class Config
	  DEFAULT_CONFIG_PATH = "config"
	
	  def initialize(parent_key=nil, parent_level=nil)
	    @parent_key = parent_key
	    @parent_level = parent_level
	    @store = {}
	    @persisted_storage = Shimmer::Storage.new(self)
	    @in_persisting_block = false
	    @observer = Shimmer::Observer.new(self)
	  end
	  
	  def parent_level
	    @parent_level
	  end
	  def parent_key
	    @parent_key || self.class::DEFAULT_CONFIG_PATH
	  end
	
	  def method_missing(input_method_name, *args, &block)
      method_name = input_method_name.to_s

	    if method_name[-1] == "="
	      save_key = method_name[0..-2]
	      
	      if @in_persisting_block
  	      unless @persisted_storage.should_include?(save_key)
	          @persisted_storage.should_include(save_key)
	        end
	        unless @persisted_storage.include?(save_key)
	          @persisted_storage.save_value(save_key, args[0])
	          @observer.call_watcher(save_key, nil, args[0])
	        else
	        	@observer.call_watcher(save_key, nil, @persisted_storage.load_value(save_key))
	        end
	      elsif !@in_persisting_block and @persisted_storage.should_include?(save_key)
  	      old_value = @persisted_storage.load_value(save_key)
	        @store[save_key] = args[0]
	        @persisted_storage.save_value(save_key, args[0])
  	      @observer.call_watcher(save_key, old_value, @store[save_key])
	      else
  	      old_value = @store[save_key]
	        @store[save_key] = args[0]
  	      @observer.call_watcher(save_key, old_value, @store[save_key])
	      end
	      
	    else
	      if include?(method_name)
	      	yield @store[method_name] if block
	        @store[method_name]
	      elsif @persisted_storage.should_include?(method_name)
	        @store[method_name] = @persisted_storage.load_value(method_name)
	        yield @store[method_name] if block
	        @store[method_name]
	      else
	        new_config = self.class.new(method_name, self)
	        yield new_config if block
	        @store[method_name] = new_config
	      end
	    end
	  end
	  
	  def persist(*keys)
	    keys = [keys] unless keys.is_a?(Array)
	    keys.each do |key|
	      @persisted_storage.should_include(key)
	    end
	  end
	  
	  def persist_defaults(&block)
	    @in_persisting_block = true
	    yield self
	    @in_persisting_block = false
	  end
	  
	  def generate_key_path
	    if @parent_level
        path_segments = [@parent_key]
        reached_top = false
        current_level = @parent_level
      
        until reached_top
          if current_level and current_level.parent_key
            path_segments << current_level.parent_key
            current_level = current_level.parent_level
          else
            reached_top = true
          end
        end
        
        path_segments.reverse.join(".")
      elsif @parent_key
        @parent_key
      else
        self.class::DEFAULT_CONFIG_PATH
	    end
	  end
	  
	  def include?(key)
	    @store.include?(key)
	  end
	  
	  def delete(key)
	    if @persisted_storage.should_include?(key)
	      @persisted_storage.delete_value(key)
	    end
	    @store.delete(key)
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
	  
	  
	  ### Observer setup
	  def watch(&block)
	    watchdsl = @observer.dsl
      if block_given?
        watchdsl.instance_eval(&block)
      end
	  end
	end
	
end