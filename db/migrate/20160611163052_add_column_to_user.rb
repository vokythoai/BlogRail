class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users,:interest ,:json,defaul: [].to_json
  end
end
