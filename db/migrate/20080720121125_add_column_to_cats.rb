class AddColumnToCats < ActiveRecord::Migration
  def self.up
    add_column :categories, :first_page, :boolean, :default => false
  end

  def self.down
    delete_column :categories, :first_page
  end
end
