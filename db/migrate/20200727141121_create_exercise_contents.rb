class CreateExerciseContents < ActiveRecord::Migration[5.1]
  def change
    create_table :exercise_contents do |t|
      t.string :name
      t.integer :calorie

      t.timestamps
    end
  end
end
