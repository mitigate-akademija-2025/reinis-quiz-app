class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.belongs_to :quiz, null: false, foreign_key: true
      t.integer :type_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
