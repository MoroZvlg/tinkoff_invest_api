RSpec.describe TinkoffInvestApi do
  let(:client) { TinkoffInvestApi::Rest::Client.new(token: "some_token") }
  before do
    allow(client.connection).to receive(:request)
  end

  # ---------------------------------------------------------------------------------------------------------------
  # Sandbox
  # ---------------------------------------------------------------------------------------------------------------
  describe "#sandbox_register" do
    subject { client.sandbox_register(account_type: "Tinkoff2") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "POST",
        path: "/sandbox/register",
        body: { brokerAccountType: "Tinkoff2" }.to_json
      )
    end
  end

  describe "#sandbox_set_balance" do
    subject { client.sandbox_set_balance(currency: "USD", amount: "1000", account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "POST",
        path: "/sandbox/currencies/balance",
        params: { brokerAccountId: "ID" },
        body: { currency: "USD", balance: "1000" }.to_json
      )
    end
  end

  describe "#sandbox_set_position" do
    subject { client.sandbox_set_position(figi: "FIGI", amount: "2", account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "POST",
        path: "/sandbox/positions/balance",
        params: { brokerAccountId: "ID" },
        body: { figi: "FIGI", balance: "2" }.to_json
      )
    end
  end

  describe "#sandbox_remove" do
    subject { client.sandbox_remove(account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "POST",
        path: "/sandbox/remove",
        params: { brokerAccountId: "ID" },
      )
    end
  end

  describe "#sandbox_clear" do
    subject { client.sandbox_clear(account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "POST",
        path: "/sandbox/clear",
        params: { brokerAccountId: "ID" },
      )
    end
  end

  # ---------------------------------------------------------------------------------------------------------------
  # Orders
  # ---------------------------------------------------------------------------------------------------------------
  describe "#orders" do
    subject { client.orders(account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/orders",
        params: { brokerAccountId: "ID" },
      )
    end
  end

  describe "#limit_order" do
    subject { client.limit_order(figi: "FIGI", lots: 2, operation: "buy", price: 10_000, account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "POST",
        path: "/orders/limit-order",
        params: { figi: "FIGI", brokerAccountId: "ID" },
        body: { lots: 2, operation: "Buy", price: 10_000 }.to_json
      )
    end
  end

  describe "#market_order" do
    subject { client.market_order(figi: "FIGI", lots: 2, operation: "buy", account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "POST",
        path: "/orders/market-order",
        params: { figi: "FIGI", brokerAccountId: "ID" },
        body: { lots: 2, operation: "Buy" }.to_json
      )
    end
  end

  describe "#cancel_order" do
    subject { client.cancel_order(order_id: "OrderID", account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "POST",
        path: "/orders/cancel",
        params: { orderId: "OrderID", brokerAccountId: "ID" },
      )
    end
  end

  # ---------------------------------------------------------------------------------------------------------------
  # Portfolio
  # ---------------------------------------------------------------------------------------------------------------
  describe "#positions_portfolio" do
    subject { client.positions_portfolio(account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/portfolio",
        params: { brokerAccountId: "ID" },
      )
    end
  end

  describe "#currencies_portfolio" do
    subject { client.currencies_portfolio(account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/portfolio/currencies",
        params: { brokerAccountId: "ID" },
      )
    end
  end

  # ---------------------------------------------------------------------------------------------------------------
  # Market
  # ---------------------------------------------------------------------------------------------------------------
  describe "#stocks_list" do
    subject { client.stocks_list }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/market/stocks",
      )
    end
  end

  describe "#bonds_list" do
    subject { client.bonds_list }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/market/bonds",
      )
    end
  end

  describe "#etfs_list" do
    subject { client.etfs_list }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/market/etfs",
      )
    end
  end

  describe "#currencies_list" do
    subject { client.currencies_list }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/market/currencies",
      )
    end
  end

  describe "#orderbook" do
    context "valid depth" do
      subject { client.orderbook(figi: "FIGI", depth: 20) }
      it do
        subject
        expect(client.connection).to have_received(:request).with(
          method: "GET",
          path: "/market/orderbook",
          params: { figi: "FIGI", depth: 20}
        )
      end
    end

    context "invalid depth" do
      subject { client.orderbook(figi: "FIGI", depth: 50) }
      it do
        expect {subject}.to raise_error(TinkoffInvestApi::RequestParamsError, "Wrong depth(50). Depth should be between 1 and 20")
      end
    end
  end

  describe "#candles" do
    context "valid interval" do
      subject { client.candles(figi: "FIGI", from: Time.new(2020, 10, 10), to: Time.new(2020, 11, 11), interval: "day") }
      it do
        subject
        expect(client.connection).to have_received(:request).with(
          method: "GET",
          path: "/market/candles",
          params: {
            figi: "FIGI",
            from: Time.new(2020, 10, 10).strftime("%Y-%m-%dT%H:%M:%S.%6N%:z"),
            to: Time.new(2020, 11, 11).strftime("%Y-%m-%dT%H:%M:%S.%6N%:z"),
            interval: "day"
          }
        )
      end
    end

    context "invalid interval" do
      subject { client.candles(figi: "FIGI", from: Time.new(2020, 10, 10), to: Time.new(2020, 11, 11), interval: "infinity") }
      it do
        expect {subject}.to raise_error(TinkoffInvestApi::RequestParamsError, "Wrong interval(infinity). Available intervals: 1min, 2min, 3min, 5min, 10min, 15min, 30min, hour, day, week, month")
      end
    end
  end

  describe "#search_by_figi" do
    subject { client.search_by_figi(figi: "FIGI") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/market/search/by-figi",
        params: { figi: "FIGI" }
      )
    end
  end

  describe "#search_by_ticker" do
    subject { client.search_by_ticker(ticker: "TCR") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/market/search/by-ticker",
        params: { ticker: "TCR" }
      )
    end
  end

  # ---------------------------------------------------------------------------------------------------------------
  # Operations
  # ---------------------------------------------------------------------------------------------------------------
  describe "#operations" do
    subject { client.operations(from: Time.new(2020, 10, 10), to: Time.new(2020, 11, 11), figi: "FIGI", account_id: "ID") }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/operations",
        params: {
          from: Time.new(2020, 10, 10).strftime("%Y-%m-%dT%H:%M:%S.%6N%:z"),
          to: Time.new(2020, 11, 11).strftime("%Y-%m-%dT%H:%M:%S.%6N%:z"),
          figi: "FIGI",
          brokerAccountId: "ID",
        }
      )
    end
  end

  # ---------------------------------------------------------------------------------------------------------------
  # User
  # ---------------------------------------------------------------------------------------------------------------
  describe "#user_accounts" do
    subject { client.user_accounts }
    it do
      subject
      expect(client.connection).to have_received(:request).with(
        method: "GET",
        path: "/user/accounts"
      )
    end
  end

end
