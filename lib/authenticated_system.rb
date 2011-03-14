module AuthenticatedSystem
  protected
  
  def current_user
    @current_user ||= User.find_by_id(session[:user])
  end
  
=begin
  #проверка административных прав 
=end
  def is_admin?
    current_user && current_user.privilegies.eql?(1)
  end
  
  def loged_in?
    current_user ? true : false
  end
   
  def check_admin
    return true if is_admin?
    
    flash[:notice] = I18n.t('general.notice_permissions_denie')
    redirect_to(request.referer ? request.referer : '/' )
    false
  end

  def check_authentificate
    unless loged_in?
      flash[:notice] = I18n.t('general.notice_authorized_area')
      redirect_to(request.referer ? request.referer : '/')  #env["HTTP_REFERER"]
      return
    end
  end
  
  def check_access
    unless can_edit(@post)
      flash[:notice] = I18n.t('general.notice_permissions_denie')
      redirect_to(request.referer ? request.referer : '/' )
      return
    end
  end
  
  def can_edit(obj)
    obj.user && obj.user.eql?(current_user) || is_admin?
  end
  
  #проверка прав на возможность редактировать даные пользователя
  def can_edit_user(user)
    current_user && (current_user.id.eql?(user.id) || is_admin?)
  end

  def rjs_check
    unless request.xhr?
      redirect_to("/")
      return false
    end
  end
  
end
