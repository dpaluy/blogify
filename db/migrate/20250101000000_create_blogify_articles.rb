# frozen_string_literal: true

class CreateBlogifyArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :blogify_articles do |t|
      t.string :title
      t.text :short_description
      t.string :featured_image
      t.text :content
      t.datetime :published_at
      t.json :meta_data
      t.string :author

      t.timestamps
    end
  end
end