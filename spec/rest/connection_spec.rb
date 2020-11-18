RSpec.describe TinkoffInvestApi do
  let(:client) { TinkoffInvestApi::Rest::Client.new(token: "some_token") }

  describe "POST request" do
    context "success" do
      it do
        stub_request(:post, "#{TinkoffInvestApi::Rest::Connection::API_ENDPOINT}/openapi/some/path?some=params").
          with(body: [{ "some" => :body }].to_json, headers: { "Authorization" => "Bearer some_token" }).
          to_return(body: { payload: { some: :response } }.to_json, status: 200)

        response = client.connection.request(method: "POST", path: "/some/path", params: { some: :params }, body: [{ some: :body }].to_json)
        expect(response).to eq({ "some" => "response" })
      end
    end

    context "failure" do
      it do
        stub_request(:post, "#{TinkoffInvestApi::Rest::Connection::API_ENDPOINT}/openapi/some/path?some=params").
          with(body: [{ "some" => :body }].to_json, headers: { "Authorization" => "Bearer some_token" }).
          to_return(body: { payload: { some: :error } }.to_json, status: 500)

        expect {
          client.connection.request(method: "POST", path: "/some/path", params: { some: :params }, body: [{ some: :body }].to_json)
        }.to raise_error(TinkoffInvestApi::TinkoffInvestApiError)
      end
    end
  end

  describe "GET request" do
    context "success" do
      it do
        stub_request(:get, "#{TinkoffInvestApi::Rest::Connection::API_ENDPOINT}/openapi/some/path?some=params").
          with(body: [{ "some" => :body }].to_json, headers: { "Authorization" => "Bearer some_token" }).
          to_return(body: { payload: { some: :response } }.to_json, status: 200)

        response = client.connection.request(method: "GET", path: "/some/path", params: { some: :params }, body: [{ some: :body }].to_json)
        expect(response).to eq({ "some" => "response" })
      end
    end

    context "failure" do
      it do
        stub_request(:get, "#{TinkoffInvestApi::Rest::Connection::API_ENDPOINT}/openapi/some/path?some=params").
          with(body: [{ "some" => :body }].to_json, headers: { "Authorization" => "Bearer some_token" }).
          to_return(body: { payload: { some: :error } }.to_json, status: 500)

        expect {
          client.connection.request(method: "GET", path: "/some/path", params: { some: :params }, body: [{ some: :body }].to_json)
        }.to raise_error(TinkoffInvestApi::TinkoffInvestApiError)
      end
    end
  end

  describe "DELETE request" do
    it do
      expect {
        client.connection.request(method: "DELETE", path: "/some/path")
      }.to raise_error(TinkoffInvestApi::UnsupportableRequestMethod)
    end
  end
end
