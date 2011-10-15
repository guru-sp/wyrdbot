module SimpleBot
  class EventListener
    class << self
      attr_writer :events

      def on(*args)
        handler = args.pop

        args.each do |event|
          events[event.to_sym] = handler
        end
      end

      def dispatch(event, payload, bot)
        events[event.to_sym].public_send(event, bot, payload)
      end

      def registered?(event)
        events.has_key?(event.to_sym)
      end

      def events
        @events ||= {}
      end
    end
  end
end
