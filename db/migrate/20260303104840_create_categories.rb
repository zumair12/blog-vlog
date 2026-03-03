# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :color, default: "#6366f1"
      t.string :icon, default: "📝"
      t.integer :posts_count, default: 0, null: false

      t.timestamps
    end

    add_index :categories, :slug, unique: true
    add_index :categories, :name, unique: true
  end
end
