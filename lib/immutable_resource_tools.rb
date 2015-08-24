# An immutable resource can only be recorded once. And further messages with the same
# uuid will be ignored. Even if their content is different.
module ImmutableResourceTools

  extend ActiveSupport::Concern

  def latest(other)
    (updated_values?(other) && ( other.last_updated > last_updated )) ? yield(self) : self
  end

  module ClassMethods
    def create_or_update(attributes)
      # return false if with_uuid(new_atts["uuid"]).exists?
      new_atts = attributes.reverse_merge(:data => attributes)
      new_record = new(new_atts)
      return nil if new_record.ignorable?
      new_record.save!
    end
    private :create_or_update
  end
end
