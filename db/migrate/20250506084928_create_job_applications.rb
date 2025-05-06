class CreateJobApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :job_applications do |t|
      t.string :candidate_name
      t.references :job_offer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
