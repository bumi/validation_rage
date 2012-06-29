module ValidationRage
  class Engine < ::Rails::Engine
    
    config.validation_rage_for = [] # set config to an empty array
    config.validation_rage_for = [ActiveRecord::Base] if defined?(ActiveRecord::Base) # really?!
    
    initializer "validation_rage.configure_validation_rage_subscriber" do |app|
      ValidationRage::LogNotifier.new(:logger => Rails.logger, :log_level => :warn).subscribe!
      app.config.validation_rage_for.each do |klass|
        klass.send(:include, ValidationRage::ModelExtension)
      end
      #ActiveRecord::Base.descendants.each {|m| m.send(:include, ValidationRage::ModelExtension) }
      #ActiveRecord::Base.send(:include, ValidationRage::ModelExtension)
    end
  end
end
