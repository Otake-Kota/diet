class CreateExerciseHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :exercise_histories do |t|
      t.references :exercise_content, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
