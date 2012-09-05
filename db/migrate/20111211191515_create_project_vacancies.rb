class CreateProjectVacancies < ActiveRecord::Migration
  def up
    create_table :project_vacancies do |t|
      t.integer :project_id, :null => false
      t.integer :vacancy_id, :null => false

      t.timestamps
    end
    add_index :project_vacancies, :project_id
    add_index :project_vacancies, :vacancy_id
  end

  def down
    drop_table :project_vacancies
  end
end
