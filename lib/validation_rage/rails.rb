module ValidationRage
  class Railtie < ::Rails::Railtie
    initializer "validation_rage.configure_validation_rage_subscriber" do
      ValidationRage::LogNotifier.new(:logger => Rails.logger, :log_level => :warn).subscribe!
      puts ActiveRecord::Base.descendants.inspect
      ActiveRecord::Base.descendants.each {|m| m.send(:include, ValidationRage::ModelExtension) }
    end
  end
end
