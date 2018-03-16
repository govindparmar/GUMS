class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :password_digest
      t.integer :organization_id
      t.boolean :is_admin
      t.string :phone_number
      t.datetime :date_of_birth

      t.timestamps
    end
  end
end
