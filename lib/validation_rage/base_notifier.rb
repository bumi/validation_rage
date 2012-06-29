module ValidationRage
  class BaseNotifier
    class NotImplementedError < StandardError; end

    def call(event_name, payload)
      raise NotImplementedError.new("your notifer must implement a call(event_name, payload) method")
    end
    def subscribe!
      ActiveSupport::Notifications.subscribe(/validation_rage:.*/, self)
    end
  end
end