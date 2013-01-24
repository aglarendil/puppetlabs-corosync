require 'spec_helper'

describe Puppet::Type.type(:cs_property) do
  subject do
    Puppet::Type.type(:cs_property)
  end

  it "should have a 'name' parameter" do
    subject.new(:name => "mock_resource")[:name].should == "mock_resource"
  end

  describe "basic structure" do
    it "should be able to create an instance" do
      provider_class = Puppet::Type::Cs_property.provider(Puppet::Type::Cs_property.providers[0])
      Puppet::Type::Cs_property.expects(:defaultprovider).returns(provider_class)

      subject.new(:name => "mock_resource").should_not be_nil
    end

    [:cib, :name ].each do |param|
      it "should have a #{param} parameter" do
        subject.validparameter?(param).should be_true
      end

      it "should have documentation for its #{param} parameter" do
        subject.paramclass(param).doc.should be_instance_of(String)
      end
    end

    
      it "should have a value property" do
        subject.validproperty?(:value).should be_true
      end

      it "should have documentation for its value property" do
        subject.propertybyname(:value).doc.should be_instance_of(String)
      end
   
  end


end
