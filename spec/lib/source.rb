require "./lib/interface/source.rb"
require "./lib/pubsub/message.rb"

module Hoze

  class TestSource < Source

    def initialize configuration
      @queue = []
    end

    def enqueue_message payload, metadata
      msg = Hoze::TestMessage.new(payload,Date.now,metadata)
      @queue << msg
      msg
    end

    def listen &block
      @queue.each do |msg|
        yield msg
      end
    end

  end

end