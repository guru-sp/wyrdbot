module SimpleIrcBot
  module Logger
    LOG_PATH = File.expand_path("../../../log/wyrd.log", __FILE__)

    def logger
      @logger ||= resolve_logger
    end

    def resolve_logger
      return ::Logger.new(STDOUT) if ARGV.member? "-t"
      ::Logger.new(LOG_PATH)
    end
  end
end
