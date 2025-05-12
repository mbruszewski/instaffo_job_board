module Eventable
  extend ActiveSupport::Concern

  included do
    has_many :events, as: :eventable, class_name: (self.to_s + "::Event").classify, dependent: :destroy

    scope :by_last_event_type, ->(event_type) {
      joins("LEFT JOIN events last_event ON last_event.eventable_id = #{table_name}.id AND last_event.eventable_type = '#{name}'")
        .where("last_event.type = ?", event_type)
        .where("NOT EXISTS (
          SELECT 1 FROM events e
          WHERE e.eventable_id = #{table_name}.id
          AND e.eventable_type = '#{name}'
          AND e.created_at > last_event.created_at
        )")
    }
    scope :except_last_event_type, ->(event_type) {
      joins("LEFT JOIN events last_event ON last_event.eventable_id = #{table_name}.id AND last_event.eventable_type = '#{name}'")
        .where("last_event.type IN (?)", event_type)
        .where("NOT EXISTS (
          SELECT 1 FROM events e
          WHERE e.eventable_id = #{table_name}.id
          AND e.eventable_type = '#{name}'
          AND e.created_at > last_event.created_at
        )")
    }


    scope :by_last_status_event, ->(event_type) {
      by_last_event_type(event_type)
        .where("last_event.type IN (?)", (self.klass.to_s + "::Event").classify.constantize::STATUS_EVENTS)
    }
  end
end
