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
    assert_equal :notify_validation_rage, @klass.after_validation_method
    assert @klass.new.respond_to?(:notify_validation_rage)
  end
  
  def test_publish_active_support_notification
    instance = @klass.new
    instance.expects(:errors).returns(mock(:to_hash=>{:errors => :hash}))
    ActiveSupport::Notifications.expects(:publish).with("validation_rage:errors", {"MockClass" => {:errors => :hash}, :context => {}})
    instance.notify_validation_rage
  end
  
  def test_passing_a_context_hash_to_notification_call
    instance = @klass.new
    instance.expects(:errors).returns(mock(:to_hash=>{:errors => :hash}))
    ActiveSupport::Notifications.expects(:publish).with("validation_rage:errors", {"MockClass" => {:errors => :hash}, :context => {:controller => "Users", :action => "edit"}})
    instance.notify_validation_rage({:controller => "Users", :action => "edit"})
  end
end