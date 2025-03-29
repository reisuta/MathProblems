class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :question_template, null: false, foreign_key: true
      t.references :parameter_set, null: false, foreign_key: true
      t.text :content
      t.text :answer
      t.text :explanation

      t.timestamps
    end
  end
end
