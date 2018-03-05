require "./lib/interface/message.rb"

module Hoze

  class TestMessage < Message

    attr_reader :delay_received, :ack_received, :reject_received

    def initialize payload,timestamp,metadata
      @payload = payload
      @timestamp = timestamp
      @metadata = metadata
      @delay_received = []
      @ack_received = []
      @reject_received = []
    end

    # Ask for more time before acknowledging
    def delay! seconds
      @delay_received << seconds
    end

    # Acknowledge the message
    def ack!
      @ack_received << "ack"
    end

    # Release the message
    def reject!
      @reject_received << "reject"
    end

  end

end