module TinkoffInvestApi
  module Rest
    module Api
      MAX_DEPTH = 20
      MIN_DEPTH = 1
      AVAILABLE_INTERVALS = %w[1min 2min 3min 5min 10min 15min 30min hour day week month]

      # ---------------------------------------------------------------------------------------------------------------
      # Sandbox
      # ---------------------------------------------------------------------------------------------------------------
      def sandbox_register(account_type: "Tinkoff")
        body = {
          brokerAccountType: account_type
        }.to_json
        request(method: "POST", path: "/sandbox/register", body: body)
      end

      def sandbox_set_balance(currency: "RUB", amount: 100_000, account_id: nil)
        params = {}
        params[:brokerAccountId] = account_id unless account_id.nil?
        body = {
          currency: currency,
          balance: amount
        }.to_json
        request(method: "POST", path: "/sandbox/currencies/balance", params: params, body: body)
      end

      def sandbox_set_position(figi:, amount:, account_id: nil)
        params = {}
        params[:brokerAccountId] = account_id unless account_id.nil?
        body = {
          figi: figi,
          balance: amount
        }.to_json
        request(method: "POST", path: "/sandbox/positions/balance", params: params, body: body)
      end

      def sandbox_remove(account_id: nil)
        params = {}
        params[:brokerAccountId] = account_id unless account_id.nil?
        request(method: "POST", path: "/sandbox/remove", params: params)
      end

      def sandbox_clear(account_id: nil)
        params = {}
        params[:brokerAccountId] = account_id unless account_id.nil?
        request(method: "POST", path: "/sandbox/clear", params: params)
      end

      # ---------------------------------------------------------------------------------------------------------------
      # Orders
      # ---------------------------------------------------------------------------------------------------------------
      def orders(account_id: nil)
        params = {}
        params[:brokerAccountId] = account_id unless account_id.nil?
        request(method: "GET", path: "/orders", params: params)
      end

      def limit_order(figi:, lots:, operation:, price:, account_id: nil)
        params = {
          figi: figi
        }
        body = {
          lots: lots,
          operation: operation.capitalize,
          price: price
        }.to_json
        params[:brokerAccountId] = account_id unless account_id.nil?
        request(method: "POST", path: "/orders/limit-order", params: params, body: body)
      end

      def market_order(figi:, lots:, operation:, account_id: nil)
        params = {
          figi: figi
        }
        body = {
          lots: lots,
          operation: operation.capitalize,
        }.to_json
        params[:brokerAccountId] = account_id unless account_id.nil?
        request(method: "POST", path: "/orders/market-order", params: params, body: body)
      end

      def cancel_order(order_id:, account_id: nil)
        params = {
          orderId: order_id
        }
        params[:brokerAccountId] = account_id unless account_id.nil?
        request(method: "POST", path: "/orders/cancel", params: params)
      end

      # ---------------------------------------------------------------------------------------------------------------
      # Portfolio
      # ---------------------------------------------------------------------------------------------------------------
      def positions_portfolio(account_id: nil)
        params = {}
        params[:brokerAccountId] = account_id unless account_id.nil?
        request(method: "GET", path: "/portfolio", params: params)
      end

      def currencies_portfolio(account_id: nil)
        params = {}
        params[:brokerAccountId] = account_id unless account_id.nil?
        request(method: "GET", path: "/portfolio/currencies", params: params)
      end

      # ---------------------------------------------------------------------------------------------------------------
      # Market
      # ---------------------------------------------------------------------------------------------------------------
      def stocks_list
        request(method: "GET", path: "/market/stocks")
      end

      def bonds_list
        request(method: "GET", path: "/market/bonds")
      end

      def etfs_list
        request(method: "GET", path: "/market/etfs")
      end

      def currencies_list
        request(method: "GET", path: "/market/currencies")
      end

      def orderbook(figi:, depth: 20)
        if depth > MAX_DEPTH || depth < MIN_DEPTH
          raise TinkoffInvestApi::RequestParamsError.new("Wrong depth(#{depth}). Depth should be between #{MIN_DEPTH} and #{MAX_DEPTH}")
        end
        params = {
          figi: figi,
          depth: depth
        }
        request(method: "GET", path: "/market/orderbook", params: params)
      end

      def candles(figi:, from:, to:, interval:)
        unless AVAILABLE_INTERVALS.include?(interval)
          raise TinkoffInvestApi::RequestParamsError.new("Wrong interval(#{interval}). Available intervals: #{AVAILABLE_INTERVALS.join(", ")}")
        end

        params = {
          figi: figi,
          from: from.strftime("%Y-%m-%dT%H:%M:%S.%6N%:z"),
          to: to.strftime("%Y-%m-%dT%H:%M:%S.%6N%:z"),
          interval: interval
        }
        request(method: "GET", path: "/market/candles", params: params)
      end

      def search_by_figi(figi:)
        params = {
          figi: figi
        }
        request(method: "GET", path: "/market/search/by-figi", params: params)
      end

      def search_by_ticker(ticker: )
        params = {
          ticker: ticker
        }
        request(method: "GET", path: "/market/search/by-ticker", params: params)
      end

      # ---------------------------------------------------------------------------------------------------------------
      # Operations
      # ---------------------------------------------------------------------------------------------------------------
      def operations(from:, to:, figi: nil, account_id: nil)
        params = {
          from: from.strftime("%Y-%m-%dT%H:%M:%S.%6N%:z"),
          to: to.strftime("%Y-%m-%dT%H:%M:%S.%6N%:z")
        }
        params[:figi] = figi unless figi.nil?
        params[:brokerAccountId] = account_id unless account_id.nil?
        request(method: "GET", path: "/operations", params: params)
      end

      # ---------------------------------------------------------------------------------------------------------------
      # User
      # ---------------------------------------------------------------------------------------------------------------
      def user_accounts
        request(method: "GET", path: "/user/accounts")
      end
    end
  end
end
