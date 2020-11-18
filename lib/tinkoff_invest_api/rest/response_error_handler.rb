module TinkoffInvestApi
  module Rest
    class ResponseErrorHandler

      attr_reader :response

      def initialize(response)
        @response = response
      end

      def handle!
        raise TinkoffInvestApiError.new(error_message)
      end

      def error_message
        "#{response.status} #{response.body}"
      end

    end
  end
end
