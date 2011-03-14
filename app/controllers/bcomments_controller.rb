class BcommentsController < ApplicationController
  before_filter :load_post
  before_filter :check_access, :only => [:edit, :update, :destroy ]
  #  before_filter :check_authentificate, :only => [:create, :new]
  
  # GET /bcomments
  # GET /bcomments.xml
  def index
    @bcomments = @post.bcomments.find(:all)

    respond_to do |format|
      format.html { render :partial =>'index', :locals => {:post => @post, :bcomments => @bcomments}} # index.html.erb
      format.xml  { render :xml => @bcomments }
    end
  end

  # GET /bcomments/1
  # GET /bcomments/1.xml
  def show
    @bcomment = @post.bcomments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bcomment }
    end
  end

  # GET /bcomments/new
  # GET /bcomments/new.xml
  def new
    @bcomment = @post.bcomments.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bcomment }
    end
  end

  # GET /bcomments/1/edit
  def edit
    @bcomment = @post.bcomments.find(params[:id])
  end

  # POST /bcomments
  # POST /bcomments.xml
  def create
    @bcomment = Bcomment.new(params[:bcomment])
    if !loged_in? && !simple_captcha_valid?
      flash[:notice] = t('general.captcha_incorrect')
      redirect_to(:back)
      return
    end

    @bcomment.user = current_user
    @post.bcomments << @bcomment
    #logger.debug(@bcomment.inspect)   
    respond_to do |format|
      if @post.save
        flash[:notice] = t('general.comment_added')
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @bcomment, :status => :created, :location => @bcomment }
      else
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @bcomment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bcomments/1
  # PUT /bcomments/1.xml
  def update
    @bcomment = @post.bcomments.find(params[:id])

    respond_to do |format|
      if @bcomment.update_attributes(params[:bcomment])
        flash[:notice] = t('general.comment_saved')
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bcomment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bcomments/1
  # DELETE /bcomments/1.xml
  def destroy
    @bcomment = @post.bcomments.find(params[:id])
    @bcomment.destroy

    respond_to do |format|
      format.html { redirect_to(@post) }
      format.xml  { head :ok }
    end
  end
  
  def load_post
    @post = Post.find(params[:post_id])
  end
  
end
