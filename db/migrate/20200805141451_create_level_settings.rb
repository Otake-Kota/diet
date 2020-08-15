class CreateLevelSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :level_settings do |t|
      t.integer :calorie

      t.timestamps
    end
    calorie = 50
    for i in 1..100
      LevelSetting.create(calorie: calorie)
      calorie *= 1.1
    end
  end
end
