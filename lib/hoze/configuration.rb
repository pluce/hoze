require "google/cloud/pubsub"

module Hoze

  class Configuration
    attr_accessor :channel, :key, :auto_ack, :connector, :max_tries

    def initialize
      @connector = ConnectorConfiguration.new
    end

    def channel
      env_config('CHANNEL') || @channel
    end

    def key
      env_config('KEY') || @key
    end

    private

    def env_config name
      return ENV["HOZE_CONFIG_#{name}"]
    end

  end

  class ConnectorConfiguration
    attr_accessor :type, :project, :path_to_key

    def type
      env_config('TYPE') || @type
    end

    def project
      env_config('PROJECT') || @project
    end

    def path_to_key
      env_config('PATH_TO_KEY') || @path_to_key
    end

    private

    def env_config name
      return ENV["HOZE_CONFIG_CONNECTOR_#{name}"]
    end
  end

end