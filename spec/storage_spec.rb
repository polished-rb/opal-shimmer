require 'spec_helper'

describe "Shimmer::Storage" do
  let(:config) { config = Shimmer::Config.new }
  
  it "generates correct paths" do
    config.somevalue = "Wow"
    expect(config.generate_key_path).to eq("config")
    
    config.several.levels.deep.lurks = "a monster!"
    expect(config.several.levels.deep.generate_key_path).to eq("config.several.levels.deep")
    
    config2 = Shimmer::Config.new(:config2)
    config2.properly.namespaces.itself = "which is cool"
    expect(config2.properly.namespaces.generate_key_path).to eq("config2.properly.namespaces")
  end
  
  it "persists a value" do
    config.persist(:cease_and_persist)
    config.cease_and_persist = "abc123"
    
    config2 = Shimmer::Config.new
    config2.persist(:cease_and_persist)
    expect(config2.cease_and_persist).to eq("abc123")
  end
  
  it "works with complex values" do
    config.persist(:somebool, :somearray, :somehash)
    
    config.somebool = true
    config.somearray = [3, 9, "a", false]
    config.somehash = {foo: "bar", baz: [3, 9]}
    
    config2 = Shimmer::Config.new
    config2.persist(:somebool, :somearray, :somehash)

    expect(config2.somebool).to eq(true)
    expect(config2.somearray).to eq([3, 9, "a", false])
    expect(config2.somehash).to eq({foo: "bar", baz: [3, 9]})
  end
  
  it "works with namespaces" do
    config.namespaced.persist(:avalue)
    config.namespaced do |spaced|
      spaced.avalue = "Groovy!"
    end
    
    config2 = Shimmer::Config.new
    config2.namespaced.persist(:avalue)
    expect(config2.namespaced.avalue).to eq("Groovy!")
  end
  
  it "allows for default values" do
    # we have to make sure localStorage is nulled out here, otherwise
    # the test will fail after the first time it's run :)
    `window.localStorage.removeItem('config.somevalue')`
    `window.localStorage.removeItem('config.othervalue')`
  
    config.persist_defaults do |c|
      c.somevalue = "abc"
      c.othervalue = 123
    end
    
    expect(config.somevalue).to eq("abc")

    config.somevalue = "xyz"    
    expect(config.somevalue).to eq("xyz")
    
    config2 = Shimmer::Config.new
    config2.persist_defaults do |c|
      c.somevalue = "abc"
      c.othervalue = 123
    end
    
    expect(config2.somevalue).to eq("xyz")
    expect(config2.othervalue).to eq(123)
  end
  
  it "can delete a value" do
    # we have to make sure localStorage is nulled out here, otherwise
    # the test will fail after the first time it's run :)
    `window.localStorage.removeItem('config.somevalue')`
    `window.localStorage.removeItem('config.othervalue')`
  
    config.persist_defaults do |c|
      c.somevalue = "abc"
      c.othervalue = 123
    end
    
    expect(config.somevalue).to eq("abc")

    config.somevalue = "xyz"    
    expect(config.somevalue).to eq("xyz")
    
    config.delete(:somevalue)
    
    config2 = Shimmer::Config.new
    config2.persist_defaults do |c|
      c.somevalue = "abc"
      c.othervalue = 123
    end
    
    expect(config2.somevalue).to eq("abc")
    expect(config2.othervalue).to eq(123)
  end 
  
end