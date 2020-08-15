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
      height = current_user.height / 100.to_f
      squ_height = height * height
      @bmi = las_weight.weight / squ_height
      #標準体重
      @bace_weight = height * height * 22
      
      @max = 0
      @min = Weight.find(1).weight
      @weights.each do |weight|
        if @max < weight.weight
          @max = weight.weight
        end
        if @min > weight.weight
          @min = weight.weight
        end
      end
    end
  end
  def management_process
    created_at = params[:weight][:created_at]
    if created_at == nil
      weight = Weight.new(weight_params.merge({user_id: current_user.id}))
    else
      weight = Weight.new(weight_params.merge({user_id: current_user.id, created_at: created_at}))
    end
    if weight.save
      redirect_to management_path and return
    else
      flash[:danger] = "ユーザー登録に失敗しました。"
      redirect_to management_path
    end
  end
  def calorie_management
    @exe_his = ExerciseHistory.where(user_id: current_user.id)
    if @exe_his == nil
      @min = 0
      @max = 100
    else
      @max = 0
      #@min = @exe_his.find(1).calorie
      @exe_his.each do |exe_his|
        if @max < exe_his.calorie
          @max = exe_his.calorie
        end
        # if @min > exe_his.calorie
        #   @min = exe_his.calorie
        # end
      end
    end
  end
  private
  def weight_params
    params.require(:weight).permit(:weight)
  end
end
