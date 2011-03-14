class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  include AuthenticatedSystem
  include ExceptionNotifiable
  
  protect_from_forgery
  helper :all
    
  filter_parameter_logging :password if RAILS_ENV.eql?('production')
  before_filter :ckeck_black_list
  before_filter :set_env
  after_filter :add_counters_and_frends

  layout :set_layout

  def set_env
    self.asset_host = RAILS_ENV.eql?('production') ?  "http://img%d.#{request.host.sub(/img\d\./,'')}" : ''
    Appl.config = (APP_CONFIG[request.host] || {})
    I18n.locale = Appl.config['lang'] || APP_CONFIG['default_lang']
    logger.debug("LOCALE: #{I18n.locale}")
  end

  def add_counters_and_frends
    @body = Liquid::Template.parse(response.body) # Parses and compiles the template
    response.body = @body.render(SiteConfig.get_template_vars)
  end
  
  def ckeck_black_list
    if request.env["HTTP_USER_AGENT"] =~ /WebCopier|Curl|Wget/
      render_404
      return
    end
  end

  def set_layout
    Appl.config['layout'] || 'index'
  end
  
  #  def search_bots
  #    robots = ['Spider', 'Meta', 'Google', 'Stack', 'Rambler', 'StackRambler', 'Spider' ,'Aport', 'Yahoo', 'MSN', 'Yandex', 'bot', 'MSIE incompatible']
  #    user_agent = request.env['HTTP_USER_AGENT']
  #    robots.detect{ |bot| bot if user_agent.match(bot)}
  #  end

end

#Конфиг сайтов зависимости от домена запроса
module Appl
  mattr_accessor(:config)
end
