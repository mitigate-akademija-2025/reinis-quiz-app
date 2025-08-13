class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.text :body
      t.references :question, null: false, foreign_key: true
      t.boolean :is_correct

      t.timestamps
    end
  end
end
