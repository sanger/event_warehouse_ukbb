class Event < ActiveRecord::Base
  # include ResourceTools
  # include SingularResourceTools
  # extend AssociatedWithRoles

  has_many :event_subjects
  has_many :subjects, through: :event_subjects

  belongs_to :event_type

  # json do


  # end

end
