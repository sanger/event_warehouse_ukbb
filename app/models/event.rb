class Event < ActiveRecord::Base
  include ResourceTools
  include ImmutableResourceTools

  has_many :event_subjects
  has_many :subjects, through: :event_subjects

  has_many :metadata

  belongs_to :event_type

  validates_presence_of :event_type
  validates_presence_of :lims_id
  validates_presence_of :occured_at
  validates_presence_of :user_identifier
  validates_uniqueness_of :uuid

  def event_type=(event_type_key)
    super(EventType.for_key(event_type_key))
  end

  def ignorable?
    event_type.nil?
  end

  def subjects=(subject_array)
  end

  def metadata=(metadata_array)
  end

  json do


  end

end
