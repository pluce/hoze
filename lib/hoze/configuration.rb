require "google/cloud/pubsub"

module Hoze

  class Configuration
    attr_accessor :channel, :key, :auto_ack, :connector, :max_tries

    def initialize prefix = nil
      @connector = ConnectorConfiguration.new prefix
      @prefix = prefix
    end

    def channel
      env_config('CHANNEL') || @channel
    end

    def key
      env_config('KEY') || @key
    end

    private

    def env_config name
      key = ["HOZE","CONFIG",@prefix,name].join('_')
      return ENV[key]
    end

  end

  class ConnectorConfiguration
    attr_accessor :type, :project, :path_to_key

    def initialize prefix = nil
      @prefix = prefix
    end

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
      key = ["HOZE","CONFIG","CONNECTOR",@prefix,name].join('_')
      return ENV[key]
    end
  end

end