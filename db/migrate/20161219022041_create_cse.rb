class CreateCse < ActiveRecord::Migration[5.0]
  def change

    create_table :users do |t|
      t.string :username
      t.timestamps
    end

    change_table :blogs do |t|
      t.belongs_to :user
    end

    create_table :cses do |t|
      t.belongs_to :user
      t.text :annotation
      t.timestamps
    end
  end
end
