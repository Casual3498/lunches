require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lunches
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Moscow' 
    #config.time_zone = 'Vladivostok' 

    
    
    config.valid_course_type_values = ['first course', 'main course', 'drink'] 
    config.holidays = ['2017-01-01', '2017-11-28']
    config.weekdays = ['2017-12-02']
    config.api_begin_time = "10:00am".to_time

    if Rails.env.test? #for testing (on holidays link for menu unavailable)
       config.weekdays << Time.current.to_date.to_s << (Time.current.to_date-7.days).to_s
    end
  end
end
