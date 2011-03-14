class UsersController < ApplicationController
  
  def index
    @users = User.paginate(:page => params[:page], :order => 'id')
    render :action => 'list'
  end
  
  before_filter :user_can_edit, :only => [ :destroy, :update, :edit,
    :change_password, :save_password]
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => :post, :only => [ :destroy, :create, :update, :add_reputation ],
  #         :redirect_to => { :action => :list }

  def show
    @user = User.find_by_id(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    #check login and emal
    if params[:user][:email] != params[:re_email]
      flash[:notice] = t('general.notice_email_incorrect')
      render :action => 'new'
      return
    elsif params[:user][:password] != params[:re_password]
      flash[:notice] = t('general.notice_password_incorrect')
      render :action => 'new'
      return
    end

    @user = User.new(params[:users])
    
    if @user.save
      flash[:notice] = t('general.notice_user_created')
      #Send email for activate user
      Mailer.deliver_user_activate(@user)
      redirect_to users_path
    else
      render :action => 'new'
    end
  end
  
  def update
    @users = User.find(params[:id])
    if @users.update_attributes(params[:users])
      flash.now[:notice] = t('general.content_updated')
      flash[:notice] = t('general.private_information_saved')
      redirect_to :action => 'edit', :id => @users
      return
    else
      flash.now[:notice] = t('general.content_updated_error')
    end
    respond_to do |format|
      format.js
    end
  end
  
  
  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = t('general.general.notice_user_droped')
    redirect_to users_path
  end
  ##########################manage profiles#########################
  def edit
    return recirect_to('/')  unless user_can_edit
    @users = params[:id] ? User.find_by_id(params[:id]) : current_user
    if @users.nil?
      flash[:notice] = t('general.user_not_found')
      redirect_to('/')
      return
    end
  end
  
  
  def change_password
  end
  
  def save_password

    if current_user[:password] != params[:password]
      #render :text=>'Не верный текущий пароль', :layout=> false
      flash.now[:notice] = t('general.current_password_incorrect')
      return
    end
    if !params[:re_password].blank? && params[:new_password].eql?(params[:re_password])
      current_user[:password] = params[:new_password]
      current_user[:crypt_password] = User.md5(params[:new_password])
      if current_user.save
        Mailer.deliver_change_password(current_user)
        flash.now[:notice] = t('general.current_password_updated')
      else
        flash.now[:notice] = t('general.content_incorrect')
      end
    else
      flash.now[:notice] = t('general.passwords_different')
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  #проверка прав на  редактирование профайла пользователя
  def user_can_edit
    if is_admin? || current_user.id.eql?(params[:id].to_i)
      true
    else
      flash[:notice] = t('general.notice_permissions_denie')
      respond_to do |format|
        format.html {redirect_to(users_path)}
        format.js
      end
      false
    end
  end
  
end
