class AddPostTranslateTable < ActiveRecord::Migration
  def self.up
    Post.create_translation_table! :title => :string, :body => :text
      say("Start translation Posts[#{I18n.locale}]")
    Post.find_each(:batch_size => 10) do |post|
      post.title = post[:title]
      post.body = post[:body]
      post.save
    end
  end

  def self.down
    Post.drop_translation_table!
  end
end
