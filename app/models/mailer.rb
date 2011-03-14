class Mailer < ActionMailer::Base

  def user_activate(user)
    email_setup(user)
    @subject    = I18n.t('general.mail_aply_register')
  end
  
  def change_password(user)
    email_setup(user)
    @subject    = I18n.t('general.mail_change_password')
  end

  def reminde_password(user)
    email_setup(user)
    @subject    = I18n.t('general.mail_reminde_password')
  end
  
  #отправка письма о подписке
  def notice(user, msg)
    email_setup(user, msg)
    @subject    = I18n.t('general.mail_describe_msg')
  end
  #отправка письма подписанным на тему на форуме
  def new_post(user, msg)
    email_setup(user, msg)
    @subject    = I18n.t('general.mail_new_msg')
  end
    
  def new_privatemsg(user)
    email_setup(user)
    @subject    = I18n.t('general.mail_new_privatemsg')
  end
  
  def system_msg(user, msg)
    email_setup(user, msg)
    @subject    = 'Информация с '+Appl.config['domain']
  end
  
  private
  def email_setup(user, msg = nil)
    @recipients = user.email
    @from       = "Сайт #{Appl.config['domain']} <#{Appl.config['admin_email']}>"
    @sent_on    = Time.now
    @body['user'] = user if user
    @body['msg'] = msg if msg
  end
end
