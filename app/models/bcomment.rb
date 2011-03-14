# == Schema Information
#
# Table name: bcomments
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  post_id    :integer
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Bcomment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post, :touch => true
  
  validates_length_of :body, :minimum => 10
  validates_presence_of :post_id
  #validates_associated :user
  
end
