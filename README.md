# ValidationRage

ValidationRage is a gem to capture validation errors from your Ruby application.
The goal is to identify usability issues in your application that are caused by validations.

Imaging a form with several field validations. ValidationRage makes it super easy to get information on what fields the users experience validation errors (and might leave because of that).

## Installation

Add this line to your application's Gemfile:

    gem 'validation_rage'


## Usage

By default ValidationRage will hook into ActiveRecord::Base and log all validation errors to your Rails log.

ValidationRage comes with an rails engine to configure your application. "config" in the following examples refer to Rails.application.config
You can configure if you want to hook into your models or controllers.

### Logging on model level ###

You can hook ValidationRage into your classes that are ActiveModel::Validation compatible.

example configuration: 

    config.validation_rage.attach_to = [User, Account, Session] # hook into the User, Account, Session classes and attach an after_validation callback to track invalid records
  
### Logging on controller level ###

The problem with attaching ValidationRage to your models is that you do not have any information about the context: where did the error happen? what parameters causes the error? 
That's why you can hook ValidationRage into your controllers. ValidationRage will add an after_callback checking your instance variables for errors.

example configuration:

    config.validation_rage.attach_to = ["users#create", "session#create"] # hook into the Users and Session controler create actions
    
    # using * to match any action or any controller:
    
    config.validation_rage.attach_to = ["*#create"] # hook into every create action. - this is done by adding the after_filter to the ApplicationController
    config.validation_rage.attach_to = ["users#*"] # hook into every action in the users controler.
    
example configuration with both model and controller level logging:

    config.validation_rage.attach_to = ["users#create", Company] # hook into the create action of the UsersController AND the Company model


### Using different notifiers ###

ValidationRage uses ActiveSupport::Notifications to publish a notification message when an validation error happened. This makes it super easy to write a listener to those events and process the validation error information.
This gem comes with different Notifiers and since the integrate with ActiveSupport::Notifiers you can use several notifiers at the same time and write your own notifer.

#### LogNotifier ####

uses the logger to log your validation errors. 

configuration:

    config.validation_rage.notifier["Log"] = {:log_level => :warn, :logger => Logger.new("log/validations.log")}

#### UdpNotifier ####

send the errors as JSON to a UDP server server

configuration:

    config.validation_rage.notifier["Udp"] = {:host => "localhost", :port => 3333}


#### ValidationRageNotifer ####

send the errors to the ValidationRage Application which gives you a nice accessible interface to analyze your data.
Signup at validationrage.com to get your API key

configuration:

    config.validation_rage.notifier["ValidationRage"] = {:api_key => "<YOUR API KEY>"}
    

