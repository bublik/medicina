ActionController::Routing::Routes.draw do |map|
  map.resources :pages

  Translate::Routes.translation_ui(map) if RAILS_ENV != "production"

  map.resources :site_configs, :path_prefix => '/admin',:controller => 'admin/site_configs'
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  map.post_atom '/posts/posts.atom', :controller => 'posts', :action => 'index'
  
  map.resources :bcomments, :users
  map.resources :categories, :path_prefix => '/admin', :name_prefix => 'admin_', 
    :controller => 'admin/categories'
  map.resources :user, :controller => 'users'
  map.resources :user, :has_many => :posts
  map.resources :category, :has_many => :posts
  map.resources :posts, :has_many => :bcomments
  map.with_options :controller => 'typus', :path_prefix => 'admin' do |i|
    i.admin_set_locale 'typus_users', :action => :set_locale
  end

  map.solutions '/about', :controller => 'pages', :action => 'show', :id  => 'about'
  map.solutions '/solutions', :controller => 'pages', :action => 'show', :id  => 'solutions'
  map.services '/services', :controller => 'pages', :action => 'show', :id  => 'services'
  map.partners '/partners', :controller => 'pages', :action => 'show', :id  => 'partners'
  map.contacts '/contacts', :controller => 'pages', :action => 'show', :id  => 'contacts'

  map.connect '', :controller => "progect"
  map.progect '/project/:action', :controller => 'progect'
  map.connect '/tags/:tag_name',:controller => 'messages',:action=>'tag'
  map.tagging '/posts/tag/*tag_name', :controller => 'posts', :action => 'tag'
  map.sitemap "/sitemap.xml", :controller => "sitemap", :action => "xml" 
  map.admin_cats_state "/admin/categories/:id/state", :controller => '/admin/categories', :action => 'state'
  map.connect ':controller/:action/:id'#
  
  map.error '*anything',  :controller => 'error',  :action => 'http', :id => 404
end
