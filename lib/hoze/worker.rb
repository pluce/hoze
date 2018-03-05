require 'hoze/source_factory'

module Hoze

  def self.worker
    Hoze::Worker.new
  end

  class Worker

    attr_accessor :source_factory

    def initialize
      @configuration = Hoze::Configuration.new
      @source_factory = Hoze::SourceFactory.new
    end

    def configure &block
      yield @configuration
      puts "Configuration is: #{@configuration.inspect}"
      self
    end

    def process &block   
      source = @source_factory.build(@configuration)
      
      source.listen do |msg|
        begin
          msg.ack! if @configuration.auto_ack
          result = yield msg
        rescue Exception => e
          msg.retry!
          raise e
        end
      end
    end
  end

end