class SimpleIrcBot
  module Logger
    LOG_PATH = File.expand_path(File.dirname(__FILE__))+"/../../log/wyrd.log"

    def logger
      @logger ||= resolve_logger
    end

    def resolve_logger
      return ::Logger.new(STDOUT) if ARGV.member? "-t"
      ::Logger.new(LOG_PATH)
    end
  end
end
