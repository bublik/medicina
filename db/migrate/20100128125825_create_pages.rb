class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :identifier
      t.string :title
      t.text :body

      t.timestamps
    end
    
    Page.create([
        {:identifier => 'about', :title => 'О компании', :body => 'About comppany'},
        {:identifier => 'solutions', :title => 'Решения', :body => 'solutions'},
        {:identifier => 'services', :title => 'Услуги', :body => 'services'},
        {:identifier => 'partners', :title => 'Партнеры', :body => 'partners'},
        {:identifier => 'contacts', :title => 'Контакты', :body => 'contacts'}
      ])
  end

  def self.down
    drop_table :pages
  end
end
