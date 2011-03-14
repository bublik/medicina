class LoginController < ApplicationController

  def index
    render :action => 'login'
  end
  
  before_filter  :rjs_check, :only => [:check_reactivate,:repassword]
  
  #TODO
  #1. add function reactivate password
  #2. pass_reset запросить ссылку для изменения пароля
  
  def login
    @site_title = t('general.auth')
    respond_to do |format|
      format.js
    end
  end
  
  
  def form_reactivate
    #render form 
  end
  
  def check_reactivate
    @user = User.find(:first,:conditions=>['login = ?',params[:user][:login]])
    unless @user.nil?
      Mailer.deliver_user_activate(@user)
    end 
    respond_to do |format|
      format.js
    end
  end
  
  def activate
    #Активизируем акаунт
    @user = User.find(:first, :conditions => [ "code_activate = ?", params[:id]])
    unless @user.nil?
      session[:user] = @user.id
      @user.active="true"
      @user.save
      flash[:notice] = t('general.notice_account_activated')
      redirect_to('/')
    else
      flash[:notice] = t('general.notice_error_activated')
      redirect_to(:action => 'login')
    end
    
  end
  
  def form_repassword
    #render form for reminde password
  end
  
  def repassword
    #
    @user = User.find(:first,:conditions=>['login = ?',params[:user][:login]])
    unless @user.nil?
      Mailer.deliver_reminde_password(@user)
    end 
  end
  
  
  def auth
    #логинимся
    respond_to do |format|
      format.js   { userparams = params[:user]
        @user = User.auth(userparams[:login], userparams[:password])
      
        if !@user.nil? &&  @user.active == false
          flash.now[:notice] = t('general.user_not_activated')
          return
        end
      
        if @user.nil? 
          #login failed
          flash.now[:notice] = t('general.login_password_not_found')
          return
        else
          #loged in
          session[:user] = @user.id
          @user.touch
        end } 
      
      format.html {
        if !current_user.nil?
          redirect_to(:action=>'login')
        else
          redirect_to(:back)
        end
      }
    end
  end
  
  def logout
    reset_session
    flash[:notice] = t('general.notice_logout')
    respond_to do |format|
      format.js
    end
  end
  
end
