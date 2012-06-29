require "test_helper"

class ValidationRage::LogNotifierTest < MiniTest::Unit::TestCase
  

  def test_defaul_log_leve
    assert_equal :warn, ValidationRage::LogNotifier.new({}).log_level
  end
  def test_log_validation_errors_to_logger
    payload = {"Class" => {:name => ["missing"]}}
    mocked_logger = mock()
    mocked_logger.expects(:info).with("event_name #{payload.inspect}")
    log_notifier = ValidationRage::LogNotifier.new(:logger => mocked_logger, :log_level => :info)
    log_notifier.call("event_name", payload)
  end

  def test_ignore_empty_errors
    mocked_logger = mock()
    mocked_logger.expects(:warn).never
    notifier = ValidationRage::LogNotifier.new(:logger => mocked_logger)
    notifier.call("event_name", "Class" => {})
  end
end