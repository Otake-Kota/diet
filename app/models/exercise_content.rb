class ExerciseContent < ApplicationRecord
    has_many :exercise_histories
    validates :name, uniqueness: true
end
