module ValidationRage
  module ControllerExtension

    def notify_validation_rage
      objects_with_errors = self.instance_variables.collect {|var_name| instance_variable_get(var_name) if validation_rage_errors_present?(var_name) }.compact
      objects_with_errors.each do |o|
        ActiveSupport::Notifications.publish("validation_rage:errors", {o.class.name => o.errors.to_hash, :context => self.validation_rage_context })
      end
    end

    def validation_rage_errors_present?(var_name)
      return false if var_name.to_s =~ /^@_/ # ignore variable names marked with "_" - those are by convention internal only
      obj = instance_variable_get(var_name)
      obj.respond_to?(:errors) && !obj.errors.empty?
    end

    def validation_rage_context
      {
        :controller   => params[:controller],
        :action       => params[:action],
        :request_path => request.path,
        :params       => request.filtered_parameters,
        :request_uuid => request.uuid,
        :referrer     => request.referrer
      }
    end
  end
end