require "test_helper"

# TODO: guess this test could be written nicer
class MockModel
  def self.after_validation(method)
    @@after_validation_method = method
  end
  def self.after_validation_method
    @@after_validation_method
  end
  def self.name
    "MockClass"
  end
end
class ValidationRage::ModelExtensionTest < MiniTest::Unit::TestCase
  
  def setup
    @klass = Class.new(MockModel)
    @klass.send(:include, ValidationRage::ModelExtension)
  end

  def test_register_after_validation_callback
    assert_equal :validation_rage_notify, @klass.after_validation_method
    assert @klass.new.respond_to?(:validation_rage_notify)
  end
  
  def test_publish_active_support_notification
    instance = @klass.new
    instance.expects(:errors).returns(mock(:to_hash=>{:errors => :hash}))
    ActiveSupport::Notifications.expects(:publish).with("validation_rage:errors", {"MockClass" => {:errors => :hash}})
    instance.validation_rage_notify
  end
end