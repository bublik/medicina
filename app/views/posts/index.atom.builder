atom_feed do |feed|
  feed.title Appl.config['site_name']
  feed.updated((@posts.first ? @posts.first.created_at : Time.now))
  
  for post in @posts
    tags = '<br/>'+post.tags.collect{|t|  
                link_to(t.name, {:controller => 'posts',
                                 :action => 'tag',
                                 :id => t.name},
                  :title=>t.name, :rel=>'tag friend colleague')
              }.join(', ')
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(post.body + tags , :type => 'html')
      entry.author do |author|
        author.name(post.user.full_name)
      end
    end
  end
end