module ValidationRage
  module ModelExtension

    def self.included(base)
      base.after_validation(:notify_validation_rage)
    end

    def notify_validation_rage(context = {})
      ActiveSupport::Notifications.publish("validation_rage:errors", {self.class.name => self.errors.to_hash, :context => context})
    end
  end
end