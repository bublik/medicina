class ProgectController < ApplicationController

  def index
    #@last_posts = Post.all(:limit => '10', :joins => :globalize_translations, :order => 'created_at DESC')
    @last_posts = Post.find_limit(10, 'created_at DESC').all(:joins => :globalize_translations, :conditions => ['locale = ? ', Appl.config['lang']])
    @random_posts = Post.find_limit(5, 'random()').all
    @categories = Category.all
    Appl.config['layout'].blank? ? return : render(:template => '/progect/'+Appl.config['layout'])
  end
  
  def help
  end

  def about
  end

  #created for about contacts partners and etc pages
  def custom
    unless @page = Page.find_by_identifier(params[:id])
      flash[:notice] = 'Page not found'
      redirect_to '/'
      return
    end
  end
  
  #  def dir
  #    #render links to other sites
  #    @files = Dir["#{RAILS_ROOT}/public/doc/pdf/*.*"].collect{|file| file.split('/').last }
  #  end

  def group
  end
end
