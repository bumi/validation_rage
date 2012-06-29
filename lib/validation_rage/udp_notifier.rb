require "socket"
module ValidationRage
  class UdpNotifier < BaseNotifier

    attr_accessor :socket
    def initialize(args)
      self.socket = UDPSocket.new
      self.socket.connect(args[:host], args[:port])
    end

    def call(event_name, payload)
      self.socket.send(payload.to_json, 0)
    end
  end

end