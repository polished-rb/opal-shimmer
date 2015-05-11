require 'spec_helper'

class CallbackTest
  attr_accessor :oldval, :newval
  def initialize
    self.oldval = "foo"
    self.newval = "bar"
  end
  def check_values(new, old, value_config)
    self.oldval = old
    self.newval = new
  end
end

describe "Shimmer::Observer" do
  let(:config) { config = Shimmer::Config.new }
  
  it "can observe stuff" do
    oldval = "foo"
    newval = "bar"
  
    config.watch do
      on :somevalue do |new, old|
        oldval = old
        newval = new
      end
    end
    
    config.somevalue = "Totally cool"
    
    expect(oldval).to eq(nil)
    expect(newval).to eq("Totally cool")
  end
  it "can continually observe stuff and access other config values" do
    oldval = "foo"
    newval = "bar"
  
    config.watch do
      on :somevalue do |new, old, value_config|
        oldval = "#{value_config.anothervalue} #{old}"
        newval = "#{new} #{value_config.anothervalue}"
      end
    end
    
    config.anothervalue = 10
    config.somevalue = "Totally cool"
    config.somevalue = 543
    
    expect(oldval).to eq("10 Totally cool")
    expect(newval).to eq("543 10")
  
  end
  it "can call a method of an object as the observer handler" do
    callback_test = CallbackTest.new

    config.callback_value = "Old stuff"
  
    config.watch do
      on :callback_value, callback_test.method(:check_values)
    end
    
    config.callback_value = "Totally awesome"
    
    expect(callback_test.oldval).to eq("Old stuff")
    expect(callback_test.newval).to eq("Totally awesome")
  end
  it "works with persisted items as well" do
    newval = "foo"
    oldval = "bar"
    newsomeval = "foo"
    oldsomeval = "bar"
    
    config.watch do
      on :somevalue  do |new, old|
        newsomeval = new
        oldsomeval = old
      end
      on :othervalue do |new, old|
        newval = new
        oldval = old
      end
    end
  
    `window.localStorage.removeItem('config.somevalue')`
    `window.localStorage.removeItem('config.othervalue')`
    
    `window.localStorage['config.othervalue'] = 321`
  
    config.persist_defaults do |c|
      c.somevalue = "abc"
      c.othervalue = 123
    end

    expect(oldsomeval).to eq(nil)
    expect(newsomeval).to eq("abc")
  
    expect(oldval).to eq(nil)
    expect(newval).to eq(321)
    
    config.othervalue = 456
    config.somevalue = "def"

    expect(oldsomeval).to eq("abc")
    expect(newsomeval).to eq("def")

    expect(oldval).to eq(321)
    expect(newval).to eq(456)
  end
end