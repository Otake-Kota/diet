class UsersController < ApplicationController
  before_action :authorize, except: [:sign_up, :sign_up_process, :sign_in, :sign_in_process]
  before_action :redirect_to_top_if_signed_in, only: [:sign_up, :sign_in]
  
  def top
    @recipe = Recipe.where(user_id: current_user.id)
    
    exercise_histories = ExerciseHistory.where(user_id: current_user.id)
    if exercise_histories
      @all_time = 0
      @all_calorie = 0
    else
      all_create = exercise_histories.sum(:created_at)
      all_update = exercise_histories.sum(:updated_at)
      all_time = all_update - all_create
      @all_time = Time.at(all_time - 9*60*60).strftime('%X')
      @all_calorie = eh.sum(:calorie)
    end
    
    last_exercise_history = ExerciseHistory.where(user_id: current_user.id).last
    if last_exercise_history == nil
      @last_exercise_history_time = 0
    else
      @last_exercise_history_time = last_exercise_history.created_at.strftime("%Y-%m-%d  %H:%M:%S")
    end
    
    @las_weight = Weight.where(user_id: current_user.id).last
    if @las_weight == nil
      @bmi = 0
    else
      height = current_user.height / 100.to_f
      squ_height = height * height
      @bmi = @las_weight.weight / squ_height
    end
  end
  def sign_up
    @user = User.new
  end
  def sign_up_process
    user = User.new(user_params.merge({image: 'dummyimage.jpg', level: 1}))
    if user.save
      user_sign_in(user)
      redirect_to top_path and return
    else
      flash[:danger] = "ユーザー登録に失敗しました。"
      redirect_to sign_up_path
    end
  end
  def sign_in
    @user = User.new
  end
  def sign_in_process
    password_md5 = User.generate_password(user_params[:password])
    user = User.find_by(email: user_params[:email], password: password_md5)
    if user
      user_sign_in(user)
      redirect_to top_path and return
    else
      flash[:danger] = 'メールアドレスかパスワードが違います'
      redirect_to sign_in_path
    end
  end
  def sign_out
    user_sign_out
    redirect_to sign_in_path and return
  end
  def profile_edit
    @user = User.find(current_user.id)
  end
  def profile_edit_process
    @user = User.find(current_user.id)
    password = params[:user][:password]
    image = params[:user][:image]
    if image.present?
      image_name = image.original_filename
      output_dir = Rails.root.join('public','images')
      output_path = output_dir + image_name
      File.open(output_path,'w+b') do |f|
        f.write(image.read)
      end
    else
      image_name = @user.image
      if image_name.blank?
        image_name = "dummyimage.jpg"
      end
    end
    if password == ""
      if current_user.update(user_edit_params.merge({image: image_name, password: @user.password}))
        redirect_to top_path and return
      else
        flash[:danger] = '更新に失敗しました。'
        redirect_to profile_edit_path
      end
    else
      if current_user.update(user_edit_params.merge({password: password, password_confirmation: params[:user][:password_confirmation], image: image_name}))
        current_user.password = User.generate_password(current_user.password)
        current_user.save(validate: false)
        redirect_to top_path and return
      else
        flash[:danger] = '更新に失敗しました。'
        redirect_to profile_edit_path
      end
    end
  end
  def post_new
    @recipe = Recipe.new
    @categories = Category.all
  end
  def post_new_process
    image = params[:recipe][:image]
    if image.present?
      image_name = image.original_filename
      output_dir = Rails.root.join('public','images')
      output_path = output_dir + image_name
      File.open(output_path,'w+b') do |f|
        f.write(image.read)
      end
    else
      image_name = current_user.image
      if image_name.blank?
        image_name = "dummyimage.jpg"
      end
    end
    recipe = Recipe.new(recipe_params.merge({image: image_name, user_id: current_user.id}))
    recipe.category_id = params[:recipe][:category]
    if recipe.save
        redirect_to top_path and return
    else
        flash[:danger] = '更新に失敗しました。'
        redirect_to post_new_path
    end
  end
  def post_cooking
    @recipies = Recipe.where(user_id: current_user.id)
  end
  def cooking_journey
    @recipe = Recipe.find(params[:id])
  end
  def post_delete
    @recipe = Recipe.find(params[:id])
    if @recipe.destroy
      flash[:delete] = "削除しました"
      redirect_to post_cooking_path
    else
      flash[:danger] = "削除に失敗しました"
      redirect_to post_cooking_path
    end
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :height, :password, :password_confirmation)
  end
  def user_edit_params
    params.require(:user).permit(:name, :email, :height)
  end
  def recipe_params
    params.require(:recipe).permit(:name, :ingredients, :journey, :trick)
  end
end
