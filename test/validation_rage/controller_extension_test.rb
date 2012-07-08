require "test_helper"

# TODO: guess this test could be written nicer
class MockController
  def request
    OpenStruct.new(:filtered_parameters => ["filtered", "params"], :path => "/mock/path", :uuid => "uuid", :referrer => "referrer")    
  end
  def params
    {:controller => "Mock", :action => "create"}
  end
  def initialize(records={})
    records.each do |name,record|
      instance_variable_set("@#{name}", record)
    end
  end
end
class ValidationRage::ControllerExtensionTest < MiniTest::Unit::TestCase

  def setup
    @klass = Class.new(MockController)
    @klass.send(:include, ValidationRage::ControllerExtension)
  end

  def test_errors_present
    assert !@klass.new(:var => "not responding to errors").validation_rage_errors_present?(:"@var")
    assert !@klass.new(:var => mock(:errors => [])).validation_rage_errors_present?(:"@var")
    assert !@klass.new(:_var => "internal only vars should be ignored").validation_rage_errors_present?(:"@_var")
    assert @klass.new(:var => mock(:errors => ["not empty"])).validation_rage_errors_present?(:"@var")
  end

  def test_validation_rage_context
    assert_equal({
      :controller   => "Mock",
      :action       => "create",
      :request_path => "/mock/path",
      :params       => ["filtered","params"], 
      :request_uuid => "uuid", 
      :referrer     => "referrer"
    }, @klass.new.validation_rage_context)
  end
  
  def test_notify_validation_rage
    record = MockModel.new
    record.expects(:errors).at_least_once.returns(mock(:"empty?"=>false, :to_hash=>{:errors => :hash}))
    controller_instance = @klass.new(:record => record, :foo => :bar)
    ActiveSupport::Notifications.expects(:publish).with("validation_rage:errors", {
      "MockClass" => {:errors => :hash}, 
      :context => {
        :controller   => "Mock", 
        :action       => "create",
        :request_path => "/mock/path",
        :params       => ["filtered","params"],
        :request_uuid => "uuid",
        :referrer     => "referrer"
      }
    })
    controller_instance.notify_validation_rage
  end

end