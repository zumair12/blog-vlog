# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.integer :status, default: 0, null: false  # 0: pending, 1: approved, 2: rejected, 3: spam
      t.integer :likes_count, default: 0, null: false

      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :comments }

      t.timestamps
    end

    add_index :comments, :status
    add_index :comments, [ :post_id, :status ]
    add_index :comments, [ :user_id, :status ]
  end
end
