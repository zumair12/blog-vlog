# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :excerpt
      t.integer :status, default: 0, null: false  # 0: draft, 1: published, 2: archived
      t.integer :views_count, default: 0, null: false
      t.boolean :featured, default: false, null: false
      t.datetime :published_at
      t.integer :reading_time, default: 0
      t.integer :comments_count, default: 0, null: false
      t.integer :likes_count, default: 0, null: false

      t.references :user, null: false, foreign_key: true
      t.references :category, null: true, foreign_key: true

      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, :status
    add_index :posts, :featured
    add_index :posts, :published_at
    add_index :posts, [ :user_id, :status ]
    add_index :posts, [ :category_id, :status ]
  end
end
