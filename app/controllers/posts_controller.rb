class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
  before_filter :check_authentificate, :only => [:new, :create]
  before_filter :init_post, :only => [ :show, :edit, :update, :destroy ]
  before_filter :check_access, :only => [:edit, :update, :destroy ]
  
  def index
    logger.debug("---------user_id #{params[:user_id]} \n-------category_id #{params[:category_id]}")
    if  !params[:user_id].nil?
      @posts = Post.paginate(:all,
        :order => 'created_at DESC',
        :conditions => ['user_id = ? AND locale = ? ', User.find_by_login(params[:user_id]), Appl.config['lang']],
        :joins => :globalize_translations,
        :page => params[:page])
    elsif !params[:category_id].nil?
      @posts = Post.paginate(:all,
        :order => 'created_at DESC',
        :conditions => ['category_id = ? AND locale = ? ', params[:category_id], Appl.config['lang']],
        :joins => :globalize_translations,
        :page => params[:page])
    else
      @posts = Post.paginate(:all,
        :order => 'created_at DESC',
        :conditions => ['locale = ? ', Appl.config['lang']],
        :joins => :globalize_translations,
        :page => params[:page])
    end
    
    if @posts.empty?
      flash[:notice] = t('general.categoty_is_empty')
      redirect_to('/')
      return
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml { render :xml => @posts }
        format.rss { render :layout => false}
        format.atom {render :layout => false}
      end
    end
  end
  
  def tag
    escaped_tag  = CGI.unescape(params[:tag_name].to_s)
    @tag_string = ''
    escaped_tag.each_char do |char|
      begin
        @tag_string << Iconv::iconv('UTF-8', 'UTF-8', char).to_s
      rescue Iconv::IllegalSequence, Iconv::InvalidCharacter
        nil
      end
    end
    
    
    #    @post_ids = Tagging.find(:all, :conditions => {'tag_id' => Tag.find(:first, :conditions => ['name LIKE ?', "#{@tag_string}%"])}
    #    ).collect(&:taggable_id)
    #
    #    if @post_ids.empty?
    #      flash[:notice] = t('general.unknown_tag')
    #      redirect_to('/')
    #      return
    #    end

    @posts = Post.find_tagged_with(@tag_string).paginate(
      :conditions => ['locale = ? ',  Appl.config['lang']],
      :order => 'updated_at DESC',
      :joins => :globalize_translations,
      :per_page => 3,
      :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @posts }
      # format.icl { render_calendar(@posts) }
      format.atom { render :action => 'atom', :content_type => Mime::ATOM }
    end
  end
  # GET /posts/1
  # GET /posts/1.xml
  def show
    @related_posts =  Post.find_tagged_with(@post.tags)[0..5]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
      format.atom { redirect_to '/posts.atom' }
    end
  end
  
  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    
    if files = params[:file]
      files.keys.each do |file_num|
        fls = {}
        fls[:uploaded_data] = files[file_num]
        @post.attachments << Attachment.new(fls)
      end
    end
    
    unless params[:category_name].eql?('')
      @post.category = Category.create(:name => params[:category_name], :title => params[:category_name])
    end
    
    @post.user = current_user
    logger.debug("CREATE POST before save" + @post.inspect)
    respond_to do |format|
      if @post.valid? && @post.save
        logger.debug("CREATE POST after save" + @post.inspect)
        flash[:notice] = t('general.notice_msg_created')
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    respond_to do |format|
      if @post.update_attributes(params[:post])

        if files = params[:file]
          files.keys.each do |file_num|
            fls = {}
            fls[:uploaded_data] = files[file_num]
            @post.attachments << Attachment.new(fls)
          end
        end

        flash[:notice] = t('general.notice_msg_updated')
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def init_post
    unless ['rss','atom'].include?(params[:format])
      if request.get?
        @post = Post.find(:first, :conditions => ['posts.id = ?', params[:id].to_i], :include => :category, :joins => :globalize_translations)
      else
        @post = Post.find_by_id(params[:id].to_i)
      end
    end
  end
  
  #  def check_access
  #    unless can_edit(@post)
  #      flash[:notice] = t('general.notice_permissions_denie')
  #      redirect_to(:action => 'index')
  #      return
  #    end
  #  end
  
end
