# == Schema Information
#
# Table name: posts
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  category_id :integer
#  title       :string(255)
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Post < ActiveRecord::Base
  acts_as_taggable
  translates :title, :body

  belongs_to :user
  belongs_to :category, :touch => true
  
  has_many :bcomments
  has_many :attachments
  
  validates_presence_of :user_id, :message => 'не может быть анонимным.'
  validates_uniqueness_of :title
  validates_length_of :title, :minimum => 5
  validates_presence_of :body
  #  validates_presence_of :category_id
  named_scope :last_posts, :include => [:globalize_translations], :order => 'created_at DESC'
  named_scope :find_limit, lambda { |limit, order|   { :limit => limit, :order => order} }
  named_scope :limit, lambda { |limit|   { :limit => limit} }
  cattr_reader :per_page
  @@per_page = 3
  @@total_entries = 15

  def to_param
    "#{self.id}-#{self.title.to_s.gsub(/[\W]/,'-')}"
  end

end
