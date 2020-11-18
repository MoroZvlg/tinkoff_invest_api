require "tinkoff_invest_api/version"

require "base64"
require "bigdecimal"
require "json"
require "uri"
require "net/https"
require "forwardable"
require "logger"

require "tinkoff_invest_api/exceptions"
require "tinkoff_invest_api/rest/api"
require "tinkoff_invest_api/rest/client"
require "tinkoff_invest_api/rest/connection"
require "tinkoff_invest_api/rest/api_response"
require "tinkoff_invest_api/rest/response_error_handler"

module TinkoffInvestApi
  class << self
    attr_accessor :logger

    def logger
      @logger ||= Logger.new(STDOUT).tap do |log|
        log.level = Logger::WARN
        log.progname = name
      end
    end

  end
end
