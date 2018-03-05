require "hoze/interface/source"
require "hoze/pubsub/message"

module Hoze

  class PubSubSource < Source

    attr_reader :topic, :subscription, :max_tries

    def initialize configuration
      @engine = Google::Cloud::Pubsub.new(
        project: configuration.connector.project,
        credentials: configuration.connector.path_to_key
      )

      @channel = configuration.channel
      @key = configuration.key

      @topic = ensure_topic
      @subscription = ensure_subscription

      @max_tries = configuration.max_tries
    end


    def listen &block
      #puts @subscription.inspect
      subscriber = @subscription.listen do |received_message|
        begin
          msg = Hoze::PubSubMessage.new(received_message, self)
          yield msg
        rescue Exception => e
          puts "Exception: #{e.message}"
          raise # always reraise
        end
      end
      subscriber.start
      begin
        puts "Starts listening"
        while true do
          sleep 10
        end
      rescue Interrupt
        puts "Interrupted, cleaning ok"
      ensure
        subscriber.stop.wait!
      end
    end
    
    private

    def ensure_topic
      @engine.topic(@channel)||@engine.create_topic(@channel)
    end

    def ensure_subscription
      @topic.subscription(@key)||@topic.subscribe(@key)
    end

  end

end