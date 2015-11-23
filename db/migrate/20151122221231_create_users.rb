class CreateUsers < ActiveRecord::Migration
  def change


    create_table :users do |t|
      t.string :provider
      t.string :uid, index: true
      t.string :name
      t.string :email
      t.string :oauth_token
      t.string :oauth_expires_at

      t.timestamps null: false
    end


    create_table :fb_pages, :fb_page_id => false do |t|
      t.string :name
      t.integer :fb_page_id, :limit => 8, index: true
      t.string :category

      t.timestamps null: false
    end


    create_table :fb_page_posts, :fb_page_id => false, :fb_post_id => false do |t|
      t.belongs_to :fb_page

      t.integer :fb_page_id, :limit => 8
      t.integer :fb_post_id, :limit => 8
      t.text :message
      t.integer :share_count
      t.integer :comment_count
      t.integer :like_count
      t.integer :impression_count
      t.datetime :date_posted

      t.timestamps null: false
    end


    create_table :fb_page_users, :fb_page_id => false do |t|
      t.belongs_to :users
      t.belongs_to :fb_page

      t.integer :fb_page_id, :limit => 8, index: true
      t.integer :user_id

      t.timestamps null: false
    end

  end
end
