class GraphController < ApplicationController
  before_action :authorize

  def management
    @weight = Weight.new
    @weights = Weight.where(user_id: current_user.id)

    las_weight = Weight.where(user_id: current_user.id).last
    if las_weight == nil
      @bmi = 0
      @bace_weight = 0
      @min = 0
      @max = 100
    else
      #BMI計算
      @bmi = las_weight.weight / ((current_user.height / 100.to_f) ** 2)
      #標準体重
      @bace_weight = ((current_user.height / 100.to_f) ** 2) * 22

      @max = 0
      @min = Weight.find(1).weight
      @weights.each do |weight|
        @max = weight.weight if @max < weight.weight
        @min = weight.weight if @min > weight.weight
      end
    end
  end
  def management_process
    created_at = params[:weight][:created_at]
    created_at == nil ? weight = Weight.new(weight_params.merge({user_id: current_user.id})) : weight = Weight.new(weight_params.merge({user_id: current_user.id, created_at: created_at}))
    if weight.save
      redirect_to management_path and return
    else
      flash[:danger] = "ユーザー登録に失敗しました。"
      redirect_to management_path
    end
  end
  def calorie_management
    @exe_his = ExerciseHistory.where(user_id: current_user.id)
    @max = 0
    @min = 0

    @exe_his.each {|exe_his| @max = exe_his.calorie if @max < exe_his.calorie} unless @exe_his == nil
    
  end
  private
  def weight_params
    params.require(:weight).permit(:weight)
  end
end
