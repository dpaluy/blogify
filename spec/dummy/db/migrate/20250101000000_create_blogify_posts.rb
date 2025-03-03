# frozen_string_literal: true

class CreateBlogifyPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :blogify_posts do |t|
      t.string :title, null: false
      t.text :short_description
      t.text :content
      t.datetime :published_at
      t.json :meta_data
      t.string :author
      t.string :slug, null: false
      t.string :meta_title
      t.text :meta_description

      t.timestamps
    end

    add_index :blogify_posts, :slug, unique: true
  end
end
