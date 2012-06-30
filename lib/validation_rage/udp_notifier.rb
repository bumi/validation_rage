require "socket"
module ValidationRage
  class UdpNotifier < BaseNotifier

    attr_accessor :socket, :host, :port
    def initialize(args)
      self.socket = UDPSocket.new
      self.host = args[:host]
      self.port = args[:port]
    end

    def call(event_name, payload)
      self.socket.send(payload.to_json, 0, self.host, self.port)
    end
  end

end