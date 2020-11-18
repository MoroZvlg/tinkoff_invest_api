module TinkoffInvestApi
  module Rest
    class ApiResponse

      attr_reader :received_at

      def initialize(response)
        @received_at = Time.now
        @response = response
      end

      def raw
        @response
      end

      def body
        JSON.parse(@response.body) rescue {}
      end

      def payload
        body["payload"]
      end

      def headers
        out = @response.to_hash.map do |key, val|
          [
            key,
            val.count == 1 ? val.first : val
          ]
        end
        out.to_h
      end

      def status
        @response.code.to_i
      end

      def success?
        status.between?(200,299)
      end

    end
  end
end
