require "test_helper"
require "socket"
class ValidationRage::UdpNotifierTest < MiniTest::Unit::TestCase

  def test_connect_to_socket
    UDPSocket.expects(:new).returns("socket")
    notifier = ValidationRage::UdpNotifier.new(:host => "localhost", :port => 33333)
    assert_equal "socket", notifier.socket
    assert_equal "localhost", notifier.host
    assert_equal 33333, notifier.port
  end

  def test_send_json_encoded_payload_through_socket
    notifier = ValidationRage::UdpNotifier.new(:host => "host", :port => "port")
    payload = {"Class" => {:error => :message}}
    socket = mock()
    socket.expects(:send).with(payload.to_json,0, "host", "port")
    notifier.expects(:socket).returns(socket)
    notifier.call("event_name", payload)
  end
end