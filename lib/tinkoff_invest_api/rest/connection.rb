module TinkoffInvestApi
  module Rest
    class Connection
      API_ENDPOINT = "https://api-invest.tinkoff.ru".freeze

      attr_reader :token, :sandbox, :connection

      def initialize(token:, sandbox: false)
        @token = token
        @sandbox = sandbox
        @connection = build_connection
      end

      def request(method:, path:, params: {}, body: nil)
        actual_path = generate_path(path, params: params)

        request = case method
        when "GET" then
          Net::HTTP::Get.new(actual_path)
        when "POST" then
          Net::HTTP::Post.new(actual_path)
        else
          raise UnsupportableRequestMethod
        end

        request.body = body unless body.nil?

        request["Content-Type"] = "application/json"
        request["User-Agent"] = "tinkoff_api/ruby/#{TinkoffInvestApi::VERSION}"
        request["Authorization"] = "Bearer #{token}"

        TinkoffInvestApi.logger.debug "Request URL: #{request.method} #{connection.use_ssl? ? "https" : "http"}://#{connection.address}#{request.path}"
        TinkoffInvestApi.logger.debug "Request Headers: #{request.to_hash}"
        TinkoffInvestApi.logger.debug "Request Body: #{request.body}"

        response = TinkoffInvestApi::Rest::ApiResponse.new(connection.request(request))

        TinkoffInvestApi.logger.debug "Response Headers: #{response.headers}"
        TinkoffInvestApi.logger.debug "Response Status: #{response.status}"
        TinkoffInvestApi.logger.debug "Response Body: #{response.body}"

        if response.success?
          response.payload
        else
          ResponseErrorHandler.new(response).handle!
        end
      end

      private

      def build_connection
        base_url = URI.parse(API_ENDPOINT)
        connection = Net::HTTP.new(base_url.host, base_url.port)
        if base_url.is_a?(URI::HTTPS)
          connection.use_ssl = true
          connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
        end
        connection
      end

      def generate_path(path, params:)
        if params.count.positive?
          "#{path_prefix}#{path}?#{URI.encode_www_form(params)}"
        else
          "#{path_prefix}#{path}"
        end
      end

      def path_prefix
        if sandbox
          "/openapi/sandbox"
        else
          "/openapi"
        end
      end

    end
  end
end
