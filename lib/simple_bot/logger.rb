module SimpleBot
  module Logger
    def logger
      @logger ||= resolve_logger
    end

    def resolve_logger
      return ::Logger.new(STDOUT) if ARGV.member? "-t"
      ::Logger.new(SimpleBot.root.join("log/wyrd.log"))
    end
  end
end
