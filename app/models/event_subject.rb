class EventSubject < ActiveRecord::Base

  belongs_to :subject
  belongs_to :event

end
