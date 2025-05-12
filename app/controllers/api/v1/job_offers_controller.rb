class Api::V1::JobOffersController < Api::V1::BaseController
  def index
    @job_offers = JobOffer
      .select(
        :id,
        "title as job_name",
        "events.type AS status",
        "(#{JobApplication.select("count(job_applications.id)").where("job_offer_id = job_offers.id").by_last_status_event(JobApplication::Event::Hired).to_sql}) AS hired_count",
        "(#{JobApplication.select("count(job_applications.id)").where("job_offer_id = job_offers.id").by_last_status_event(JobApplication::Event::Rejected).to_sql}) AS rejected_count",
        "(#{JobApplication.select("count(job_applications.id)").where("job_offer_id = job_offers.id").except_last_event_type([ JobApplication::Event::Hired, JobApplication::Event::Rejected ]).to_sql}) AS ongoing_count"
      )
      .left_outer_joins(:events)
      .where("events.type IN (?)", JobOffer::Event::STATUS_EVENTS)
      .group("job_offers.id, events.type, events.created_at")
      .order("events.created_at ASC")

    render json: @job_offers
  end
end
