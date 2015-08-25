module ResourceTools::TypeDictionary

  RECORD_NOT_UNIQUE_RETRIES = 3

  module ClassMethods

    attr_reader :default_description

    def for_key(key)
      tries = 0
      begin
        self.preregistration_required? ? where(key:key).first : create_with(description:default_description).find_or_create_by(key:key)
      rescue ActiveRecord::RecordNotUnique => e
        # If we have two similar events arriving at the same time, we might conceivably run into a
        # race condition. We retry a few times, then give up and re-raise our exception;
        tries += 1
        if (tries <= RECORD_NOT_UNIQUE_RETRIES)
          retry
        else
          raise e
        end
      end
    end

    def has_default_description(description)
      @default_description = description
    end

    def preregistration_required(bool)
      @preregistration_required = bool
    end

    def preregistration_required?
      # Default to false
      @preregistration_required||false
    end

  end

  def self.included(base)
    base.class_eval do

      validates_presence_of :key
      validates_uniqueness_of :key

      validates_presence_of :description

      extend ClassMethods
    end
  end

  # Include in MyClass to set up MyClassType associations and setters
  module HasDictionary
    def self.included(base)
      base.class_eval do

        type_assn = "#{self.name.downcase}_type"
        type_class = "#{self.name}Type".constantize

        belongs_to :"#{type_assn}"
        define_method(:"#{type_assn}=") do |assn_key|
          super(type_class.for_key(assn_key))
        end

      end
    end
  end

end
