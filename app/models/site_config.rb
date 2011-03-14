# == Schema Information
#
# Table name: site_configs
#
#  id         :integer         not null, primary key
#  body       :text
#  identifier :string(255)
#  is_active  :boolean         default(TRUE)
#  disable_at :date
#  created_at :datetime
#  updated_at :datetime
#

class SiteConfig < ActiveRecord::Base
  translates :body

  validates_uniqueness_of :identifier
  
  def self.get_template_vars
    vars = {}
    all(:conditions => ['is_active = ? AND (disable_at IS NULL OR disable_at >= ?) AND site_config_translations.locale = ? ', true, Time.current, I18n.locale.to_s],
      :include => [:globalize_translations]).collect{|row|
      vars[row.identifier] = row.body
    }
    vars
  end
end
