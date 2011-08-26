module SimpleIrcBot
  module Logger
    def logger
      @logger ||= resolve_logger
    end

    def resolve_logger
      return ::Logger.new(STDOUT) if ARGV.member? "-t"
      ::Logger.new(SimpleIrcBot.root.join("log/wyrd.log"))
    end
  end
end
