# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  first_page :boolean
#

class Category < ActiveRecord::Base
  has_many :posts, :include => [:globalize_translations]
  validates_length_of :name, :minimum => 4, :message=>'Слишком короткое название'
  
  def title
    "#{self.name}"
  end
end
