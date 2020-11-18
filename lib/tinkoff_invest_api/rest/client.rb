module TinkoffInvestApi
  module Rest
    class Client
      API_ENDPOINT = "https://api-invest.tinkoff.ru".freeze
      include TinkoffInvestApi::Rest::Api
      extend Forwardable

      attr_reader :token, :connection
      def_delegator :connection, :request, :request

      def initialize(token: nil, sandbox: false, log_level: :warn)
        @token = token
        @connection = TinkoffInvestApi::Rest::Connection.new(token: token, sandbox: sandbox)
        TinkoffInvestApi.logger.level = log_level
      end

    end
  end
end
