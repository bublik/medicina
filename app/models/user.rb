# == Schema Information
#
# Table name: users
#
#  id             :integer         not null, primary key
#  login          :string(15)      default(""), not null
#  email          :string(50)      default(""), not null
#  first_name     :string(20)      default(""), not null
#  last_name      :string(20)      default(""), not null
#  avatar         :string(50)      default(""), not null
#  privilegies    :integer         default(2)
#  raiting        :integer         default(0)
#  password       :string(32)      default(""), not null
#  crypt_password :string(32)      default(""), not null
#  active         :boolean
#  code_activate  :string(32)
#  birth_day      :datetime
#  icq_number     :integer
#  home_page      :string(100)
#  location       :string(100)
#  interests      :string(100)
#  job            :string(100)
#  description    :string(255)     default("")
#  created_at     :datetime
#  updated_at     :datetime
#

require 'digest/md5'

class User < ActiveRecord::Base
  attr_protected :privilegies

  has_many :posts, :include => [:globalize_translations]
  has_many :bcomments

  validates_length_of    :password, :in => 4..31
  validates_length_of    :login, :in => 4..16
 
  validates_uniqueness_of :login
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^(.+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => I18n.t('general.notice_email_incorrect')
  validates_format_of :login, :with => /^[-a-z0-9_]+$/i, :message=> 'incorrect charsets, a-z and 0-9 chars'
  
  cattr_reader :per_page
  @@per_page = 10

  def before_create
    #Инициализируем начальные установки пользователя
    self.privilegies = 3
    self.crypt_password = User.md5(self.password)
    self.birth_day = Time.now
    self.active = false
    self.code_activate = User.md5(Time.now.to_s)
  end
  
  def full_name
    if !self.first_name.empty? || !self.last_name.empty?
      "#{self.first_name} #{self.last_name}"
    else
      self.login
    end
  end

  def grant_admin!
    self.update_attribute(:privilegies, 1)
  end
  
  private 

  def self.privilegies
    %w( 0 1 2 3 )
  end

  def self.md5(password)
    Digest::MD5.hexdigest(password)
  end

  def self.auth(login, password)
    self.find(:first, :conditions => ["login = ? AND crypt_password = ?", login, md5(password)])
  end

end
