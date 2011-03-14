# == Schema Information
#
# Table name: pages
#
#  id         :integer         not null, primary key
#  identifier :string(255)
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Page < ActiveRecord::Base
  validates_presence_of :identifier
  validates_length_of :title, :within => 3..100

  def to_param
    self.identifier
  end
end
