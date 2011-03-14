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

require 'test_helper'

class PageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
