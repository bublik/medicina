module PostsHelper
  def tagged_body(post)
    text = post.body
    post.tags.each do |t|
      tag = ' '+link_to(t.name, tagging_url(t.name), :title => t.name, :rel => 'tag')+' '
      text.gsub!(/(#{Regexp.escape(t.name)})/, tag)
    end
    text
  end
end
