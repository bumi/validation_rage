module ValidationRage
  class Engine < ::Rails::Engine

    config.validation_rage = ActiveSupport::OrderedOptions.new

    config.validation_rage.attach_to = [] 
    config.validation_rage.attach_to = [ActiveRecord::Base] if defined?(ActiveRecord::Base) # really?!

    config.validation_rage.notifier = {"Log" => {:log_level => :warn, :logger => nil}} # defalt log everything to the logger

    initializer "validation_rage.configure_subscribers" do |app|
      # TODO move this into a testable setup method and refactor! -

      if app.config.validation_rage # if validation rage is enabled
        app.config.validation_rage.notifier.each do |name, options|
          options[:logger] ||= Rails.logger
          ValidationRage.const_get("#{name}Notifier").new(options).subscribe! # initialize the notifier and subscribe to the active suppot notification messages
        end

        # attach validation rage integration extensions to controllers (with after filter) or models (with after_validation filters) 
        controllers = {}
        app.config.validation_rage.attach_to.each do |klass_or_action|
          # if its a string we collect the controller and actions to later add a after_filter
          if klass_or_action.is_a?(String)
            controller, action = klass_or_action.split("#")
            controllers[controller] ||= []
            controllers[controller] << action
          else
            klass.send(:include, ValidationRage::ModelExtension)
          end
        end
        # now addingt the after filter to controllers
        controllers.each do |controller, actions|
          controller = "Application" if controller == "*"
          controller_class = "#{controller}Controller".classify.constantize rescue next # just ignore errors for now
          controller_class.send(:include, ValidationRage::ControllerExtension)
          options = {:only => actions} unless actions.any? {|a| a == "*"}
          controller_class.send(:after_filter, :notify_validation_rage, options)
        end
      end
    end
  end
end
