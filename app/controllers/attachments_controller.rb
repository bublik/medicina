class AttachmentsController < ApplicationController
  before_filter  :rjs_check, :only => [:destroy]
  before_filter :check_access, :only => [:destroy]
  
  def index
    flash[:notice] = 'Да нет тут нифига!'
    redirect_to('/')
    return
  end
  
  def destroy
    atach = Attachment.find_by_id(params[:id])
    if atach.nil? || !can_edit(atach)
      flash[:notice] = t('general.notice_permissions_denie')
      return
    end

    @all_attaches = atach.post
    flash[:notice] = (@destroy = atach.destroy ?  t('general.file_deleted') : t('general.file_not_deleted'))
    
    respond_to do |format|
      format.js   { render } 
    end
  end
  
  #TODO add
  def show
  end
end
