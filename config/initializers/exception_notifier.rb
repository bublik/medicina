ExceptionNotifier.email_prefix = "[EXCEPTION]"
ExceptionNotifier.sender_address = APP_CONFIG['exception_from']  #%("Application Error" <app.error@myapp.com>)
ExceptionNotifier.exception_recipients = APP_CONFIG['exception_to']  #%w(joe@schmoe.com bill@schmoe.com)

class ActionMailer::Base
  include ActionController::UrlWriter

#  default_url_options[:protocol] = APP_CONFIG['app_server']
  default_url_options[:host] = APP_CONFIG['domain']
#  default_url_options[:port] = APP_CONFIG['port'] unless APP_CONFIG['app_server']['port'].blank?
end

