require "socket"
module ValidationRage
  class ValidationRageNotifier < BaseNotifier

    attr_accessor :socket, :host, :port, :api_key
    def initialize(args)
      self.socket = UDPSocket.new
      self.host = "localhost"
      self.port = 33333
      self.api_key = args[:api_key]
    end

    def call(event_name, payload)
      data = {:api_key => self.api_key, :payload => payload}
      self.socket.send(data.to_json, 0, self.host, self.port)
    end
  end

end