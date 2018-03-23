require 'hoze/source_factory'

module Hoze

  def self.worker
    Hoze::Worker.new
  end

  class Worker

    attr_accessor :source_factory

    def initialize
      @source_config = Hoze::Configuration.new
      @source_factory = Hoze::SourceFactory.new
    end

    def listen_to &block
      yield @source_config
      puts "Source Configuration is: #{@source_config.inspect}"
      self
    end

    def push_to &block
      @destination_config = Hoze::Configuration.new 'DEST'
      yield @destination_config
      puts "Destination Configuration is: #{@destination_config.inspect}"
      self
    end

    def process &block
      @process_fn = Proc.new do |msg|
        yield msg
      end
      self
    end

    def go!
      @source = @source_factory.build(@source_config)
      @destination = @source_factory.build(@destination_config) if @destination_config
      @source.listen do |msg|
        begin
          msg.ack! if @source_config.auto_ack
          result = @process_fn.call msg
          @destination.push result, msg.metadata if @destination
        rescue Exception => e
          msg.retry!
          raise e
        end
      end
    end
  end

end