class CreateQuizzes < ActiveRecord::Migration[8.0]
  def change
    create_table :quizzes do |t|
      t.string :title
      t.text :description
      t.integer :owner_id

      t.timestamps
    end
  end
end
