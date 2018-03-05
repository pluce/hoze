require "google/cloud/pubsub"
require "hoze/pubsub/source"

module Hoze

  class SourceFactory

    def initialize
    end

    def build configuration
      case configuration.connector.type
      when 'pubsub'
         Hoze::PubSubSource.new configuration
      else
        raise Exception.new("Connector #{configuration.connector[:type]} not implemented")
      end
    end

  end

end
