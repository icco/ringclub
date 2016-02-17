class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :url
      t.datetime :posted_at
      t.text :content
    end
  end
end
