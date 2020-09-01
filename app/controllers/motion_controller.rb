class MotionController < ApplicationController
  before_action :authorize

  def index
    @exercise_contents = ExerciseContent.all
  end


  def index_process
    start_time = Time.at(params[:start_time].to_i / 1000)
    end_time = Time.at(params[:end_time].to_i / 1000)
    exercise_content = params[:exercise_content]
    exe_con = ExerciseContent.find(exercise_content)
    calorie = (Time.at(params[:end_time].to_i / 1000) - Time.at(params[:start_time].to_i / 1000)) * exe_con.calorie
    calorie = calorie / 60

    new_exercise_history = ExerciseHistory.new(exercise_content_id: exercise_content, user_id: current_user.id, calorie: calorie, created_at: start_time, updated_at: end_time)
    if new_exercise_history.save
      eh = ExerciseHistory.where(user_id: current_user.id)
      all_calorie = eh.sum(:calorie)

      level = current_user.level
      level_settings = LevelSetting.all
      level_settings.each do |level_setting|
        if all_calorie >= level_setting.calorie
          all_calorie -= level_setting.calorie
          level += 1
        end
      end
      if current_user.update(level: level)
        redirect_to motion_details_path(new_exercise_history.id)
      else
        flash[:danger] = '運動履歴の保存に失敗しました'
        redirect_to index_process_path
      end
    else
      frash[:danger] = 'すみません。運動履歴の保存に失敗しました'
      redirect_to index_process_path
    end
  end


  def details
    @ex_his = ExerciseHistory.find(params[:id])

    @time = @ex_his.updated_at - @ex_his.created_at
    @sec = @time
    @min = 0
    @hour = 0
    while 60 < @time do
      @time -= 60
      @min += 1
      if 60 < @min
        @min = 0
        @hour += 1
      end
    end
  end
end
