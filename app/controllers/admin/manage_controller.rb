class Admin::ManageController < ApplicationController
  before_filter  :check_admin 
  
  def index
   #defalt page for admin
  end

  def mail_new
    #render for m for send mail to users
  end

  def mail_send
    msg = params[:mail][:message]
    logger.debug(params[:mail][:test].inspect)
    if msg && params[:mail][:test].eql?('0')
      logger.debug('Send mails to all users.')
      User.find(:all).each do |u|
        Mailer.deliver_system_msg(u, msg)
      end
    else
      logger.debug('Send test email to me.')
      Mailer.deliver_system_msg(current_user, msg)
    end
    flash[:notice] = 'Письма разосланы.'
    redirect_to :action => 'index'
  end
  
  def destroy_inactiv_users
    User.destroy_all(['active = ? ', false])
    flash[:notice] = 'Не активные пользователи удалены.'
    redirect_to :action => 'index'    
  end
  
  def db_optimization
    @tables = ActiveRecord::Base.connection.select_rows("show tables")
    @tables = @tables - ["schema_info"]
    @tables.flatten!
      
    if params[:start]
      @tables.each do |table|
        case ActiveRecord::Base.establish_connection.config[:adapter]
        when 'mysql'
          ActiveRecord::Base.connection.execute("OPTIMIZE TABLE #{table} ") 
        when 'postgres'
          ActiveRecord::Base.connection.execute("VACUUM #{table};  REINDEX table")
        else  
          # ничего не делать
        end
      end
      flash[:notice] = 'База ортимизирована.'
      redirect_to :action => 'index'
    end
  end
end
