require "active_support/notifications"
require 'rails'
module ValidationRage
  autoload :Version, "validation_rage/version"
  autoload :BaseNotifier, "validation_rage/base_notifier"
  autoload :LogNotifier, "validation_rage/log_notifier"
  autoload :ModelExtension, "validation_rage/model_extension"
end