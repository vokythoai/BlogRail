class CreatePostData < ActiveRecord::Migration
  def change
    create_table :post_data do |t|
      t.string :title
      t.string :url

    end
  end
end
