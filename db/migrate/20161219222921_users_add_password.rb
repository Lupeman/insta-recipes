class UsersAddPassword < ActiveRecord::Migration[5.0]
  def change

    change_table :users do |t|
      t.text :password_digest
    end

  end
end
