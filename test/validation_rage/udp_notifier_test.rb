require "test_helper"
require "socket"
class ValidationRage::UdpNotifierTest < MiniTest::Unit::TestCase

  def test_connect_to_socket
    socket = mock()
    socket.expects(:connect).with("localhost", 33333)
    UDPSocket.expects(:new).returns(socket)
    ValidationRage::UdpNotifier.new(:host => "localhost", :port => 33333)
  end

  def send_json_encoded_payload_through_socket
    notifier = ValidationRage::UdpNotifier.new()
    payload = {"Class" => {:error => :message}}
    socket = mock()
    socket.expects(:send).with(payload.to_json,0)
    
    notifier.call("event_name", payload)
  end
end