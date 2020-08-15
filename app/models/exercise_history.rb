class ExerciseHistory < ApplicationRecord
  belongs_to :exercise_content
  belongs_to :user
  
  
end
