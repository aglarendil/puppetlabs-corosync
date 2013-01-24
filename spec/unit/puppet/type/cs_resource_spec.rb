require 'spec_helper'

describe Puppet::Type.type(:cs_resource) do
  subject do
    Puppet::Type.type(:cs_resource)
  end

  it "should have a 'name' parameter" do
    subject.new(:name => "mock_resource")[:name].should == "mock_resource"
  end

  describe "basic structure" do
    it "should be able to create an instance" do
      provider_class = Puppet::Type::Cs_resource.provider(Puppet::Type::Cs_resource.providers[0])
      Puppet::Type::Cs_resource.expects(:defaultprovider).returns(provider_class)

      subject.new(:name => "mock_resource").should_not be_nil
    end

    [:name, :primitive_class, :primitive_type, :provided_by, :cib].each do |param|
      it "should have a #{param} parameter" do
        subject.validparameter?(param).should be_true
      end

      it "should have documentation for its #{param} parameter" do
        subject.paramclass(param).doc.should be_instance_of(String)
      end
    end

    [:parameters, :operations, :metadata, :ms_metadata, :multistate].each do |property|
      it "should have a #{property} property" do
        subject.validproperty?(property).should be_true
      end

      it "should have documentation for its #{property} property" do
        subject.propertybyname(property).doc.should be_instance_of(String)
      end
    end
  end

  describe "when validating attributes" do
    [:parameters, :operations, :metadata, :ms_metadata].each do |attribute|
      it "should validate that the #{attribute} attribute defaults to a hash" do
        subject.new(:name => "mock_resource")[:parameters].should == {}
      end

      it "should validate that the #{attribute} attribute must be a hash" do
        expect { subject.new(
          :name       => "mock_resource",
          :parameters => "fail"
        ) }.to raise_error Puppet::Error, /hash/
      end
    end

    it "should validate that the promotable attribute can be true/false" do
      [:clone, :master, false].each do |value|
        subject.new(
          :name       => "mock_resource",
          :multistate => value
        )[:multistate].should == value.to_s.to_sym
      end
    end

    it "should validate that the promotable attribute cannot be other values" do
      ["fail", 42].each do |value|
        expect { subject.new(
          :name       => "mock_resource",
          :multistate => value
        ) }.to raise_error Puppet::Error, /(master|clone|false)/
      end
    end
  end
end
