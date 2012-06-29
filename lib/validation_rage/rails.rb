module ValidationRage
  class Engine < ::Rails::Engine
    
    config.validation_rage = ActiveSupport::OrderedOptions.new

    config.validation_rage.attach_to = [] 
    config.validation_rage.attach_to = [ActiveRecord::Base] if defined?(ActiveRecord::Base) # really?!
    
    config.validation_rage.notifier_options            = ActiveSupport::OrderedOptions.new
    config.validation_rage.notifier_options.logger     = nil # seems we do not have access to the default logger here. so we set the default in the initializer
    config.validation_rage.notifier_options.log_level  = :warn
    config.validation_rage.notifier                    = "Log"

    initializer "validation_rage.configure_validation_rage_subscriber" do |app|
      app.config.validation_rage.notifier_options.logger ||= Rails.logger
      
      ValidationRage.const_get("#{app.config.validation_rage.notifier}Notifier").new(app.config.validation_rage.notifier_options).subscribe!
      app.config.validation_rage.attach_to.each do |klass|
        klass.send(:include, ValidationRage::ModelExtension)
      end
      #ActiveRecord::Base.descendants.each {|m| m.send(:include, ValidationRage::ModelExtension) }
      #ActiveRecord::Base.send(:include, ValidationRage::ModelExtension)
    end
  end
end
