module ValidationRage
  class LogNotifier < BaseNotifier
    attr_accessor :logger, :log_level
    def initialize(args)
      self.logger     = args[:logger]
      self.log_level  = args[:log_level]  || :warn
    end
    def call(event_name, payload)
      return if payload.values.first && payload.values.first.empty?
      self.logger.send(self.log_level, "#{event_name} #{payload}")
    end
  end
end