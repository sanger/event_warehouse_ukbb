class Role < ActiveRecord::Base

  belongs_to :subject
  belongs_to :event

end
