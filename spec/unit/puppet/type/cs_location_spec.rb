require 'spec_helper'

describe Puppet::Type.type(:cs_location) do
  subject do
    Puppet::Type.type(:cs_location)
  end

  it "should have a 'name' parameter" do
    subject.new(:name => "mock_resource")[:name].should == "mock_resource"
  end

  describe "basic structure" do
    it "should be able to create an instance" do
      provider_class = Puppet::Type::Cs_location.provider(Puppet::Type::Cs_location.providers[0])
      Puppet::Type::Cs_location.expects(:defaultprovider).returns(provider_class)
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

    [:rules,:node_score].each do |property|
      it "should have a #{property} property" do
        subject.validproperty?(property).should be_true
      end
      it "should have documentation for its #{property} property" do
        subject.propertybyname(property).doc.should be_instance_of(String)
      end

    end

  end

end
