class SitemapController < ApplicationController

  def xml
    @messages = Post.all(:order => "updated_at DESC", :limit => 25000)
    @tags = Post.tag_counts
    @last_updated = @messages[0].updated_at
    headers["Content-Type"] = "text/xml"
    headers["Last-Modified"] = @last_updated.httpdate
    render :layout => false
  end
end
