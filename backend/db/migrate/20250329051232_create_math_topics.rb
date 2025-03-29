class CreateMathTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :math_topics do |t|
      t.string :name
      t.text :description
      t.integer :grade
      t.string :subject

      t.timestamps
    end
  end
end
