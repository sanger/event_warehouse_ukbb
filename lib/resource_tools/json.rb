module ResourceTools::Json
  extend ActiveSupport::Concern

  module ClassMethods
    def create_or_update_from_json(json_data,lims)
      create_or_update(json.collection_from(json_data,lims))
    end

    def json(&block)
      const_set(:JsonHandler, Class.new(ResourceTools::Json::Handler)) unless const_defined?(:JsonHandler)
      const_get(:JsonHandler).tap { |json_handler| json_handler.instance_eval(&block) if block_given? }
    end
    private :json
  end

  class Handler < Hashie::Mash
    class_attribute :translations
    self.translations = {}

    class_attribute :ignoreable
    self.ignoreable = []

    class_attribute :stored_as_boolean
    self.stored_as_boolean = []

    class_attribute :recorded
    self.recorded = false

    class_attribute :custom_values
    self.custom_values = nil

    class << self
      # Hashes in subkeys might as well be normal Hashie::Mash instances as we don't want to bleed
      # the key conversion further into the data.
      def subkey_class
        Hashie::Mash
      end

      def ignore(*attributes)
        self.ignoreable += attributes.map(&:to_s)
      end

      def store_as_boolean(*attributes)
        self.stored_as_boolean += attributes.map(&:to_s)
      end

      # JSON attributes can be translated into the attributes on the way in.
      def translate(details)
        self.translations = Hash[details.map { |k,v| [k.to_s, v.to_s] }].reverse_merge(self.translations)
      end

      def convert_key(key)
        translations[key.to_s] || key.to_s
      end
      # Remove privacy due to rails delegation changes
      #private :convert_key

      def collection_from(json_data,lims)
        new(json_data.reverse_merge(:lims_id=>lims))
      end

      def has_own_record
        self.recorded = true
      end

      def custom_value(name,&block)
        self.custom_values = Hash.new if self.custom_values.blank?
        self.custom_values[name] = block
      end
    end

    def initialize(*args, &block)
      super
      self.class.custom_values.each do |k,block|
        self[k] = self.instance_eval(&block)
      end if self.class.custom_values.present?
      convert_booleans
      delete_if { |k,_| ignoreable.include?(k) }
    end

    def convert_booleans
      self.stored_as_boolean.each do |key|
        self[key] = self[key].to_boolean_from_arguments if self.has_key?(key)
      end
    end
    private :convert_booleans

    def deleted?
      deleted_at.present?
    end

    delegate :convert_key, :to => 'self.class'

    translate(:updated_at => :last_updated, :created_at => :created)
  end
end
