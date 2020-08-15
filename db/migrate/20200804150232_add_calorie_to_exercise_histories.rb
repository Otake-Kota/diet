class AddCalorieToExerciseHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :exercise_histories, :calorie, :integer
  end
end
