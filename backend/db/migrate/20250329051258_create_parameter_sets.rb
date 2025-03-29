class CreateParameterSets < ActiveRecord::Migration[7.1]
  def change
    create_table :parameter_sets do |t|
      t.references :question_template, null: false, foreign_key: true
      t.jsonb :parameters

      t.timestamps
    end
  end
end
