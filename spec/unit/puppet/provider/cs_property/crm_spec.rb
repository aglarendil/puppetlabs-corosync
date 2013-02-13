require 'spec_helper'

def mocked_instances
   
  instances = []
  raw = File.open(File.dirname(__FILE__) + '/../../../../fixtures/cib/cib.xml')
  doc = REXML::Document.new(raw)

  doc.root.elements['configuration/crm_config/cluster_property_set'].each_element do |e|
    items = e.attributes
    property = { :name => items['name'], :value => items['value'] }

    property_instance = {
      :name       => property[:name],
      :ensure     => :present,
      :value      => property[:value],
      :provider   => :crm
    }
    instances << Puppet::Type.type(:cs_property).new(property_instance)
  end
  instances
end

describe Puppet::Type.type(:cs_property).provider(:crm) do

  let(:resource) { Puppet::Type.type(:cs_property).new(:name => 'myproperty', :provider=> :crm ) }
  let(:provider) { resource.provider }

  describe "#create" do

    it "should create property with corresponding value" do
      resource[:value]= "myvalue"

      provider.expects(:crm).with('configure', 'property', '$id="cib-bootstrap-options"', "myproperty=myvalue")

      provider.create
      provider.flush

    end
  end

  describe "#destroy" do
    it "should destroy property with corresponding name" do
      provider.expects(:cibadmin).with('--scope', 'crm_config', '--delete', '--xpath', "//nvpair[@name='myproperty']")
      provider.destroy
      provider.flush
    end
  end

  describe "#instances" do
    it "should find instances" do
      provider.class.stubs(:instances).returns(mocked_instances)
      provider.class.instances.should include(Puppet::Type.type(:cs_property).new({:name=>"dc-version",:value=>"1.1.6-9971ebba4494012a93c03b40a2c58ec0eb60f50c", :ensure=>:present, :provider=>:crm}))
    end
    
    it "should try to create non-existing resource" do
      resource[:value]='myvalue1'
      provider.expects(:crm).with('configure', 'property', '$id="cib-bootstrap-options"', "myproperty=myvalue1")
      provider.create
      provider.flush
    end
    
    it "should not try to create existing resource" do
      resource[:name] = "dc-version"
      resource[:value] =  "1.1.6-9971ebba4494012a93c03b40a2c58ec0eb60f50c"
      #provider.expects(:crm).with('configure', 'property', '$id="cib-bootstrap-options"', "dc-version=1.1.6-9971ebba4494012a93c03b40a2c58ec0eb60f50c").never
      provider.class.stubs(:instances).returns(mocked_instances)
      provider.class.stubs(:block_until_ready).returns(true)
      provider.class.prefetch(mocked_instances)
      #provider.exists?.should be_true
      #provider.create
      #provider.flush
    end
    
  end

end