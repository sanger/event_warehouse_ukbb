module ResourceTools
  require 'resource_tools/core_extensions'

  extend ActiveSupport::Concern
  include ResourceTools::Json

  include ResourceTools::Timestamps

  included do |base|

    # scope :updating, lambda { |r| where(:uuid => r.uuid).current }

    # The original data information is stored here
    attr_accessor :data

    # Before saving store whether this is a new record.  This allows us to determine whether we have inserted a new
    # row, which we use in the checks of whether the AmqpConsumer is working: if the ApiConsumer inserts a row then
    # we're probably not capturing all of the right messages.
    before_save :remember_if_we_are_a_new_record

    scope :for_lims,  lambda { |lims| where(lims_id:lims) }
    scope :with_uuid, lambda { |uuid| where(uuid:uuid)}
  end

  def remember_if_we_are_a_new_record
    @inserted_record = new_record?
    true
  end
  private :remember_if_we_are_a_new_record

  def inserted_record?
    @inserted_record
  end

  def related
    self.class.for_uuid(self.uuid)
  end


  IGNOREABLE_ATTRIBUTES = [ 'dont_use_id' ]

  def updated_values?(object)
    us, them = self.attributes.stringify_keys, object.attributes.stringify_keys.reverse_slice(IGNOREABLE_ATTRIBUTES)
    not us.within_acceptable_bounds?(them)
  end

end
