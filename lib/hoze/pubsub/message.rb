require "hoze/interface/message"

module Hoze

  class PubSubMessage < Message

    def initialize source_message, source
      @payload = source_message.data
      @timestamp = source_message.published_at
      @metadata = source_message.attributes
      @metadata['tries'] = (@metadata['tries'].to_i || 0) + 1
      @source_message = source_message
      @source = source
      @acked = false
    end

    # Ask for more time before acknowledging
    def delay! seconds
      @source_message.delay! seconds
    end

    # Acknowledge the message
    def ack!
      @source_message.ack! unless @acked
      @acked = true
    end

    # Release the message
    def reject!
      @source_message.reject!
    end

    # Retry the message
    def retry!
      ack!
      retry_config = @source.max_tries || 1
      if @metadata['tries'] < retry_config
        puts "RETRYING: #{@metadata['tries']} / #{retry_config}"
        @source.topic.publish_async(@payload, @metadata)
      else
        puts "Dead message #{@source_message.inspect}"
      end
    end

  end

end