module ApplicationHelper
  include AuthenticatedSystem
  @@icons = {}

  def google_analytix_adds
    return '' if Appl.config['google_analytix_uid'].blank?
    '<script type="text/javascript">
      window.google_analytics_uacct = "'+Appl.config['google_analytix_uid']+'";
    </script>'
  end
  
  #Установка статуса пользователей
  def user_mode(flag, h = nil)
    #/*1-admin 2-user 3-moderator */
    mode = {
      1 => {:text => t('general.admin_'), :color => 'red'},
      2 => {:text => t('general.moderator_'), :color => 'green'},
      3 => {:text => t('general.user_'), :color => 'blue'},
      4 => {:text => t('general.guest_'), :color => 'orange'}
    }
    t('general.guest_'); return if mode[flag].nil?
    mode[flag]; return unless h
    content_tag(:span, mode[flag][:text], :class => mode[flag][:color])
  end
  
  def tagged_links
    Post.tag_counts(:order => 'RANDOM()', :limit => 5)
  end
  
  def link_user(user, style_class = nil)
    user ? link_to(user.full_name, user_path(user,:html), :title=> user.full_name, :class=> style_class) : t('general.guest_')
  end
  
  def link_user_post(user, style_class = nil)
    user ? link_to(t('general.messages'), user_posts_path(user.login, :html), :title=> user.full_name, :class=> style_class)+" [#{user.posts.count}]" : t('general.guest_')
  end

  def link_to_new_post
   loged_in? ? link_to(t('general.write_new_article'), new_post_path, :class => 'orange') : ''
  end
  
  def attachment_list(post, limit = nil)
    return if post.new_record? || post.attachments.empty? 
    logger.debug(post.attachments.inspect)
    list = ''
    count = 0
    post.attachments.each do |attach| 
      list += ( attach.image? ?
          link_to(image_tag(attach.public_filename(:thumb),
            :alt => "#{post.title} #{attach.filename.humanize}")+"<br/> #{post.title}", attach.public_filename,
          :title => "#{post.title} #{attach.filename.humanize}", :rel => 'nofollow') :
          link_to("#{attach.filename.humanize} #{number_to_human_size(attach.size)}", attach.public_filename )) +
        (post.user.eql?(current_user) ? link_to_remote(image_tag('/images/ico/cancel.gif'),
          :url => {:controller => 'attachments', :action => 'destroy', :id => attach } ) : '')
      count += 1
      return content_tag(:div, list, :class => 'small pad5 images_post') if limit && limit.eql?(count)
    end
    content_tag(:div, list, :style => 'float: right', :class => 'small pad5 images_post')
  end
  
  def to_name(text)
    text.to_s.gsub(/[^\._\-a-zа-я0-9\@]/i,'_')
  end
  
  def can_edit_message(msg)
    !current_user.nil? && (current_user.id.eql?(msg.user_id) || current_user.privilegies < 3)
  end
  
  def msg_to_html(mesg)
    message_sanitize(mesg) #function form /lib/sanitize.rb
  end
 
  #Get online user from DB
  def online
    whos_online = Array.new(); guests = 0; users = 0
    onlines = ActiveRecord::SessionStore::Session.find(:all, :conditions => ['updated_at > ?', Time.now.utc()-10.minutes])
    ActiveRecord::SessionStore::Session.delete_all(['updated_at < ?', Time.now() - 7.days])
    guests = onlines.size
    onlines.each do |online|
      unless online.data[:user].nil?
        whos_online << link_user(User.find_by_id(online.data[:user]))+', '
        users += 1
      end
    end
    content_tag(:div, t('general.guests_online') + " #{guests - users} " +
        t('general.users_online') + (users.eql?(0) ? '0' : whos_online.uniq.join(' ')),
      :class => 'l replay')
  end

  def title(text)
    text = "#{text} (#{t('general.page')} #{params[:page]})" if params[:page]
    content_for(:title){ h(text) }
  end

  def description(text)
    text ||= ''
    content_for(:description){ h(text) }
  end

  def keywords(text)
    content_for(:keywords){ h(text) }
  end

  def hot_tags
    content_tag(:div, content_tag(:h2,t('general.key_words'))+
        Post.tag_counts(:order => 'count desc', :limit => 20).collect{|tag|
        link_to(tag.name,
          {:controller => 'posts', :action => 'tag', :id => tag.name},
          :class =>'s6 block', :title => tag.name )}.to_s)
  end
  
  def flash_and_find(flash)
    logger.debug('flash notice '+flash[:notice].inspect)
    '<span id="loading" class="loading c" style="display:none;">Loading...</span>
     <div id="flash" style="' + (flash[:notice].nil? ? 'display:none;' : '')+'">' + (flash[:notice].nil? ? '' : flash[:notice] ) + '</div>
  <div id="login"  style="display:none;">Login form </div>'
  end
  
  def categories_list
    content_tag :div, :class => 'sidebar' do
      content_tag(:h1, t('general.sections')) +
        content_tag(:ul,
        Category.find(:all, :conditions => ['first_page = ?', true]).collect{ |c|
          content_tag(:li, link_to(c.name, category_posts_url(c), :title => c.name))
        }.to_s)
    end
  end
  
end
