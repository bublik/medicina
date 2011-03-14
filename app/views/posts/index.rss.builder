xml.instruct! :xml, :version=>"1.0" 
    xml.rss(:version=>"2.0" , 
	    "xmlns:content"=>"http://purl.org/rss/1.0/modules/content/",
	    "xmlns:wfw"=>"http://wellformedweb.org/CommentAPI/", 
	    "xmlns:dc"=>"http://purl.org/dc/elements/1.1/"){
       xml.channel{
       xml.title(Appl.config['site_name'])
       xml.link('http://'+Appl.config['domain'])
       xml.description(Appl.config['description'])

       xml.language('ru-ru')
       for post in @posts
         tags = '<br/>'+post.tags.collect{|t|  
                link_to(t.name, {:controller => 'posts',
                                 :action => 'tag',
                                 :id => t.name},
                   :title=>t.name, :rel=>'tag friend colleague')
              }.join(', ')
        xml.item do
          xml.title(post.title)
          xml.author(post.user.full_name)
          xml.pubDate(post.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.description(post.body+tags) 
          xml.guid(url_for(:only_path => false, :controller => 'posts', :action => 'show', :id => post.id))
          xml.link(url_for(:only_path => false, :controller => 'posts', :action => 'show', :id => post.id))
         # xml.guid
        end
       end
       }
    }

