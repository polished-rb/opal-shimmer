require 'spec_helper'

describe "Shimmer" do
  let(:config) { config = Shimmer::Config.new }

  it "can set a single value" do
    config.somevalue = "Wow"
    
    expect(config.somevalue).to eq("Wow")
  end
  
  it "can set a namespaced valued" do
    config.namespace.coolvalue = "Way awesome!"
    
    expect(config.namespace.coolvalue).to eq("Way awesome!")  
  end
  
  it "can check nil when something doesn't exist" do
    expect(config.foo.nil?).to eq(true)
  end
  
  it "can call to_s on a blank value to get a blank string" do
    expect(config.nothing.elsewill.matter.to_s).to eq("")
  end
  
  it "can call to_i on a blank value to get 0" do
    expect(config.supah.cool.to_i).to eq(0)
  end

  it "can call to_bool on a blank value to get false" do
    expect(config.golden.gate.to_bool).to eq(false)
  end
  
  it "can get a string printout of options" do
    config.namespace.firstvalue = "abc"
    config.namespace.secondvalue = 123
    
    expect(config.namespace.to_s).to eq("{\"firstvalue\"=>\"abc\", \"secondvalue\"=>123}")
  end
  
  it "can get an options hash" do
    config.namespace.firstvalue = "abc"
    config.namespace.secondvalue = 123

    expect(config.namespace.to_h).to be_a(Hash)
  end
  
  it "can set a previous value to nil" do
    config.avalue = [0,5,10]
    config.avalue = nil
    
    expect(config.avalue.nil?).to eq(true)
  end
  
  it "can check for existance of a value" do
    expect(config.include?(:avalue)).to eq(false)
    config.avalue = [0,5,10]
    expect(config.include?(:avalue)).to eq(true)
    expect(config.some.nested.include?(:avalue)).to eq(false)
    config.some.nested.avalue = {:foo => "bar"}
    expect(config.some.nested.include?(:avalue)).to eq(true)
    expect(config.some.include?(:nested)).to eq(true)
    expect(config.some.include?(:bested)).to eq(false)
  end
end