module ValidationRage
  module ModelExtension

    def self.included(base)
      base.after_validation :validation_rage_notify
    end

    def validation_rage_notify
      ActiveSupport::Notifications.publish("validation_rage:errors", {self.class.name => self.errors.to_hash})
    end
  end
end