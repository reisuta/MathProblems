class CreateQuestionTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :question_templates do |t|
      t.references :math_topic, null: false, foreign_key: true
      t.string :title
      t.text :question_formula
      t.text :solution_steps
      t.integer :difficulty

      t.timestamps
    end
  end
end
