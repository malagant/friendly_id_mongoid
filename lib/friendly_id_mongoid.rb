require 'friendly_id/mongoid_adapter/configuration'
require 'friendly_id/mongoid_adapter/slug'
require 'friendly_id/mongoid_adapter/simple_model'
require 'friendly_id/mongoid_adapter/slugged_model'
# require 'friendly_id/mongoid_adapter/tasks'
require 'forwardable'

module FriendlyId
  module MongoidAdapter

    include FriendlyId::Base

    def has_friendly_id(method, options = {})
      extend FriendlyId::MongoidAdapter::ClassMethods
      @friendly_id_config = Configuration.new(self, method, options)

      if friendly_id_config.use_slug?
        include ::FriendlyId::MongoidAdapter::SluggedModel
      else
        include ::FriendlyId::MongoidAdapter::SimpleModel
      end
    end

    module ClassMethods
      attr_accessor :friendly_id_config
    end

  end
end

Mongoid::Model.append_extensions FriendlyId::MongoidAdapter
