require "validation_rage/version"
require "active_support/notifications"
require 'validation_rage/rails' if defined?(Rails)
module ValidationRage
  autoload :BaseNotifier, "validation_rage/base_notifier"
  autoload :LogNotifier, "validation_rage/log_notifier"
  autoload :FnordMetricNotifier, "validation_rage/fnord_metric_notifier"
  autoload :ModelExtension, "validation_rage/model_extension"
end