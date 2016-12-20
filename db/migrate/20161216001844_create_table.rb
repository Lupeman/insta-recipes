class CreateTable < ActiveRecord::Migration[5.0]
  def change
    create_table :blogs do |t|
      t.string :blog_name
      t.string :url

      t.timestamps
    end
  end
end
