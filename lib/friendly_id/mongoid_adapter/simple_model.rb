module FriendlyId
  module MongoidAdapter

    module SimpleModel

      def self.included(base)
        base.class_eval do
          column = friendly_id_config.column
          validates_presence_of column, :unless => :skip_friendly_id_validations
          validates_length_of column, :maximum => friendly_id_config.max_length, :unless => :skip_friendly_id_validations
          validates_with_method column, :method => :validate_friendly_id, :unless => :skip_friendly_id_validations

          before :update do
            @old_friendly_id = original_attributes[properties[friendly_id_config.column]]
          end

          after :update, :update_scopes
        end

        def base.get(*key)
          if key.size == 1
            return super if key.first.unfriendly_id?
            column     = self.friendly_id_config.column
            repository = self.repository
            key        = self.key(repository.name).typecast(key)
            result     = self.first(column.to_sym => key)
            return super unless result
            result.friendly_id_status.name = name
            result
          else
            super
          end
        end
      end

      # Get the {FriendlyId::Status} after the find has been performed.
      def friendly_id_status
        @friendly_id_status ||= Status.new(:record => self)
      end

      # Returns the friendly_id.
      def friendly_id
        send friendly_id_config.column
      end

      # Returns the friendly id, or if none is available, the numeric id.
      def to_param
        (friendly_id || _id).to_s
      end

      private

      # Update the slugs for any model that is using this model as its
      # FriendlyId scope.
      def update_scopes
        if @old_friendly_id != friendly_id
          friendly_id_config.child_scopes.each do |klass|
            Slug.all(:sluggable_type => klass, :scope => @old_friendly_id).update(:scope => friendly_id)
          end
        end
      end

      def friendly_id_config
        self.class.friendly_id_config
      end

      def skip_friendly_id_validations
        friendly_id.nil? && friendly_id_config.allow_nil?
      end

      def validate_friendly_id
        if result = friendly_id_config.reserved_error_message(friendly_id)
          [false, result.join(' ')]
        else
          true
        end
      end

    end
  end
end
