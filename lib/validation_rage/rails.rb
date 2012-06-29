module ValidationRage
  class Engine < ::Rails::Engine

    config.validation_rage = ActiveSupport::OrderedOptions.new

    config.validation_rage.attach_to = [] 
    config.validation_rage.attach_to = [ActiveRecord::Base] if defined?(ActiveRecord::Base) # really?!

    config.validation_rage.notifier = {"Log" => {:log_level => :warn, :logger => nil}} # defalt log everything to the logger

    initializer "validation_rage.configure_subscribers" do |app|
      # TODO move this into a testable setup method
      if app.config.validation_rage
        app.config.validation_rage.notifier.each do |name, options|
          options[:logger] ||= Rails.logger
          ValidationRage.const_get("#{name}Notifier").new(options).subscribe!
        end
        app.config.validation_rage.attach_to.each do |klass|
          klass.send(:include, ValidationRage::ModelExtension)
        end
      end
    end
  end
end
