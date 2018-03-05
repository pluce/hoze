module Hoze

  class Message

    attr_reader :payload, :timestamp, :metadata, :source, :source_message
    
    # Ask for more time before acknowledging
    def delay! seconds
      raise NotImplementedError.new("This message implementation doesn't support delay! method.")
    end

    # Acknowledge the message
    def ack!
      raise NotImplementedError.new("This message implementation doesn't support ack! method.")
    end

    # Release the message
    def reject!
      raise NotImplementedError.new("This message implementation doesn't support reject! method.")
    end

    # Retry the message
    def retry!
      raise NotImplementedError.new("This message implementation doesn't support retry! method.")
    end

  end

end