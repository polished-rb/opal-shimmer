module Shimmer
  class Observer
    def initialize(config_object)
      @config_object = config_object
      @handlers = {}
      @dsl = DSL.new(self)
    end
    
    def add_watcher(key, block)
      @handlers[key] = block
    end
    
    def call_watcher(key, old, new)
      if @handlers[key]
        @handlers[key].call(new, old, @config_object)
      end
    end
    
    def dsl
      @dsl
    end
    
    class DSL
      def initialize(observer)
        @observer = observer
      end
      def on(key, passed_method=nil, &block)
        if passed_method
          @observer.add_watcher(key, passed_method)
        else
          @observer.add_watcher(key, block)
        end
      end
    end
  end
end