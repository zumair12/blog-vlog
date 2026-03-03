# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :color, default: "#8b5cf6"
      t.integer :posts_count, default: 0, null: false

      t.timestamps
    end

    add_index :tags, :slug, unique: true
    add_index :tags, :name, unique: true
  end
end
