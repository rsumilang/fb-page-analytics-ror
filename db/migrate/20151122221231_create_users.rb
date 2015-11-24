class CreateUsers < ActiveRecord::Migration
  def change

    #
    # USERS
    #
    create_table :users do |t|
      t.string :provider
      t.string :uid, index: true
      t.string :name
      t.string :email
      t.string :oauth_token
      t.string :oauth_expires_at

      t.timestamps null: false
    end

    add_index :users, [:provider, :uid], :unique => true


    #
    # FB PAGES
    #
    create_table :fb_pages, :fb_page_id => false do |t|
      t.string :name
      t.integer :fb_page_id, :limit => 8
      t.string :category

      t.timestamps null: false
    end

    add_index :fb_pages, :fb_page_id, :unique => true


    #
    # FB PAGES POSTS
    #
    create_table :fb_page_posts do |t|
      t.belongs_to :fb_page

      t.integer :fb_page_id
      t.string :fb_post_id
      t.text :message
      t.integer :share_count
      t.integer :comment_count
      t.integer :like_count
      t.integer :impression_count
      t.datetime :date_posted

      t.timestamps null: false
    end

    add_index :fb_page_posts, [:fb_page_id, :fb_post_id], :unique => true


    #
    # FB PAGES USER
    #
    create_table :fb_page_users do |t|
      t.belongs_to :users
      t.belongs_to :fb_page

      t.integer :fb_page_id, index: true
      t.integer :users_id, index: true

      t.timestamps null: false
    end

    add_index :fb_page_users, [:fb_page_id, :users_id], :unique => true


  end
end
