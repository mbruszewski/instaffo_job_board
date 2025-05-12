class Api::V1::JobApplicationsController < Api::V1::BaseController
  def index
    # this could be moved to a class or some scope service
    # but for now, let's keep it simple
    @activated_jobs = JobApplication.with_active_jobs.select(
      "id",
      "job_offers.title AS job_name",
      "candidate_name",
      # for the state we would need to use some mapping
      "(SELECT events.type FROM events WHERE events.eventable_id = job_applications.id AND events.eventable_type = 'JobApplication' AND events.type IN (#{JobApplication::Event::STATUS_EVENTS.map { |event| "'#{event}'" }.join(", ")}) ORDER BY created_at DESC LIMIT 1) AS status",
      "COUNT(events.id) FILTER (WHERE events.type = '#{JobApplication::Event::Note}') AS notes_count",
      "MAX((events.data ->> 'interview_date')::timestamp) FILTER (WHERE events.type = '#{JobApplication::Event::Interview}') AS last_interview_date"
    ).joins(:job_offer)
     .left_joins(:events)
     .group("job_applications.id, job_offers.title, candidate_name")
     .order("job_applications.id ASC")

    render json: @activated_jobs
  end
end
