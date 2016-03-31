class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|

      t.timestamps null: false
      t.string :content
      t.integer :article_id
      t.integer :user_id
    end
  end
end
