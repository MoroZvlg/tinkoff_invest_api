# TinkoffInvestApi

Simple [Tinkoff Invest API](https://tinkoffcreditsystems.github.io/invest-openapi/) wrapper


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tinkoff_invest_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tinkoff_invest_api

## Usage

     client = TinkoffInvestApi::Rest::Client.new(token: "t.oken", sandbox: true, log_level: :warn)

### Sandbox
    client.sandbox_register(account_type: "Tinkoff")
    => {"brokerAccountType"=>"Tinkoff", "brokerAccountId"=>"SB2102303"}

    client.sandbox_set_balance(currency: "RUB", amount: 100_000, account_id: "SB2102303")
    => {}

    client.sandbox_set_position(figi: "BBG000PSKYX7", amount: 2, account_id: "SB2102303")
    => {}

    client.sandbox_remove(account_id: "SB2102303")
    => {}

    client.sandbox_clear(account_id: "SB2102303")
    => {}

### Orders

    client.orders(account_id: "SB2102303")
     => [{"orderId"=>"af12144d-acb6-468f-a637-2486b71c7b4c", "figi"=>"BBG000C46HM9", "operation"=>"Sell", "status"=>"New", "requestedLots"=>1, "executedLots"=>0, "price"=>10.0, "type"=>"Limit"}]

    client.limit_order(figi: "BBG000PSKYX7", lots: 1, operation: "buy", price: 150, account_id: "SB2102303")
    => {"orderId"=>"af12144d-acb6-468f-a637-2486b71c7b4c", "operation"=>"Sell", "status"=>"New", "requestedLots"=>1, "executedLots"=>0, "commission"=>{"currency"=>"USD", "value"=>0}}


    client.market_order(figi: "BBG000PSKYX7", lots: 1, operation: "sell", account_id: "SB2102303")
    => {"orderId"=>"af12144d-acb6-468f-a637-2486b71c7b4c", "operation"=>"Sell", "status"=>"Fill", "requestedLots"=>1, "executedLots"=>1}

    client.cancel_order(order_id: "af12144d-acb6-468f-a637-2486b71c7b4c", account_id: "SB2102303")
    => {}

### Positions

    client.positions_portfolio( account_id: "SB2102303")
     => {"positions"=>[{"figi"=>"BBG000PSKYX7", "ticker"=>"V", "isin"=>"US92826C8394", "instrumentType"=>"Stock", "balance"=>1, "blocked"=>0, "lots"=>1, "name"=>"Visa"}, {"figi"=>"BBG0013HGFT4", "ticker"=>"USD000UTSTOM", "instrumentType"=>"Currency", "balance"=>9850.0, "blocked"=>0, "lots"=>9, "name"=>"Доллар США"}]}

    client.currencies_portfolio(account_id: "SB2102303")
    => {"currencies"=>[{"currency"=>"EUR", "balance"=>0}, {"currency"=>"RUB", "balance"=>100000.0}, {"currency"=>"USD", "balance"=>9950.0}]}

### Market Data

    client.stocks_list
    => {"instruments"=>[{"figi"=>"BBG000HLJ7M4", "ticker"=>"IDCC", "isin"=>"US45867G1013", "minPriceIncrement"=>0.01, "lot"=>1, "currency"=>"USD", "name"=>"InterDigItal Inc", "type"=>"Stock"},...]}

    client.bonds_list
    => {"instruments"=>[{"figi"=>"BBG00T22WKV5", "ticker"=>"SU29013RMFS8", "isin"=>"RU000A101KT1", "minPriceIncrement"=>0.01, "faceValue"=>1000.0, "lot"=>1, "currency"=>"RUB", "name"=>"ОФЗ 29013", "type"=>"Bond"},...]}

    client.etfs_list
    => {"instruments"=>[{"figi"=>"BBG333333333", "ticker"=>"TMOS", "isin"=>"RU000A101X76", "minPriceIncrement"=>0.002, "lot"=>1, "currency"=>"RUB", "name"=>"Тинькофф iMOEX", "type"=>"Etf"},...]}

    client.currencies_list
    => {"instruments"=>[{"figi"=>"BBG0013HGFT4", "ticker"=>"USD000UTSTOM", "minPriceIncrement"=>0.0025, "lot"=>1000, "currency"=>"RUB", "name"=>"Доллар США", "type"=>"Currency"},...]}

    client.orderbook(figi: "BBG000PSKYX7", depth: 1)
    =>  {"figi"=>"BBG000PSKYX7", "depth"=>1, "tradeStatus"=>"NormalTrading", "minPriceIncrement"=>0.01, "lastPrice"=>210.71, "closePrice"=>212.7, "limitUp"=>221, "limitDown"=>203.2, "bids"=>[{"price"=>210.67, "quantity"=>60}], "asks"=>[{"price"=>211.78, "quantity"=>1}]}

    client.candles(figi: "BBG000PSKYX7", from: Time.new(2020, 10, 12), to: Time.new(2020, 10, 13), interval: "day")
    => {"candles"=>[{"o"=>207.36, "c"=>206.4, "h"=>207.99, "l"=>200.5, "v"=>832593, "time"=>"2020-10-12T07:00:00Z", "interval"=>"day", "figi"=>"BBG000PSKYX7"}], "interval"=>"day", "figi"=>"BBG000PSKYX7"}

    client.search_by_figi(figi: "BBG000PSKYX7")
    => {"figi"=>"BBG000PSKYX7", "ticker"=>"V", "isin"=>"US92826C8394", "minPriceIncrement"=>0.01, "lot"=>1, "currency"=>"USD", "name"=>"Visa", "type"=>"Stock"}

    client.search_by_ticker(ticker: "V")
    => {"instruments"=>[{"figi"=>"BBG000PSKYX7", "ticker"=>"V", "isin"=>"US92826C8394", "minPriceIncrement"=>0.01, "lot"=>1, "currency"=>"USD", "name"=>"Visa", "type"=>"Stock"}], "total"=>1}

### Operations

    client.operations(from: Time.new(2020, 11, 16), to: Time.new(2020, 11, 19), account_id: "SB2102303")
    => {"operations"=>[{"operationType"=>"Buy", "date"=>"2020-11-18T00:22:05.554237+03:00", "isMarginCall"=>false, "instrumentType"=>"Stock", "figi"=>"BBG000PSKYX7", "quantity"=>1, "price"=>100.0, "payment"=>-100.0, "currency"=>"USD", "status"=>"Done", "id"=>"8594111"},...]}

### User

    client.user_accounts
    => {"accounts"=>[{"brokerAccountType"=>"Tinkoff", "brokerAccountId"=>"SB2102303"}]}


## TODO

* WebSocket client
* Separate exception class for each API error

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
