module ValidationRage
  class FnordMetricNotifier < BaseNotifier
    attr_accessor :fnord

    def initialize(args={})
      self.fnord = FnordMetric::API.new(:redis_url => args[:redis_url])
    end

    def call(event_name, payload)
      return unless data_present?(payload)

      # global validation error event
      self.fnord.event({
        :_type => event_name,
        :payload => payload
      })
      # class level validation error event
      self.fnord.event({
        :_type => "validation_rage_error.#{payload.keys.first.to_s.downcase}",
        :payload => payload.values.first.keys
      })
      # attribute level validation error event
      payload.values.first.each do |attribute, error_messages|
        self.fnord.event({
          :_type => "validation_rage_error.#{payload.keys.first.to_s.downcase}.#{attribute}",
          :payload => error_messages
        })
      end
    end
  end
end