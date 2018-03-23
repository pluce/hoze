module Hoze

  class Source

    attr_reader :engine, :channel, :key

    def listen &block
      raise NotImplementedError.new("This source implementation doesn't support listen method.")
    end

    def push payload, metadata
      raise NotImplementedError.new("This source implementation doesn't support push method.")
    end
    
  end

end