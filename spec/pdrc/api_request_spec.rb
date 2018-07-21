require 'spec_helper'
require 'webmock/rspec'

describe PDRC::APIRequest do
  let(:api_key) { "1234-us1" }

  before do
    @pdrc = PDRC::Request.new(api_key: api_key)
    @api_root = "https://api.pagerduty.com"
  end

  it "surfaces client request exceptions as a PDRC::PagerdutyError" do
    exception = Faraday::Error::ClientError.new("the server responded with status 503")
    stub_request(:get, "#{@api_root}/teams").to_raise(exception)
    expect { @pdrc.teams.retrieve }.to raise_error(PDRC::PagerdutyError)
  end

  it "surfaces an unparseable client request exception as a PDRC::PagerdutyError" do
    exception = Faraday::Error::ClientError.new("the server responded with status 503")
    stub_request(:get, "#{@api_root}/teams").to_raise(exception)
    expect { @pdrc.teams.retrieve }.to raise_error(PDRC::PagerdutyError)
  end

  it "surfaces an unparseable response body as a PDRC::PagerdutyError" do
    response_values = {:status => 503, :headers => {}, :body => '[foo]'}
    exception = Faraday::Error::ClientError.new("the server responded with status 503", response_values)

    stub_request(:get, "#{@api_root}/teams").to_raise(exception)
    expect { @pdrc.teams.retrieve }.to raise_error(PDRC::PagerdutyError)
  end

  context "handle_error" do
    it "includes status and raw body even when json can't be parsed" do
      response_values = {:status => 503, :headers => {}, :body => 'A non JSON response'}
      exception = Faraday::Error::ClientError.new("the server responded with status 503", response_values)
      api_request = PDRC::APIRequest.new(builder: PDRC::Request)
      begin
        api_request.send(:handle_error, exception)
      rescue => boom
        expect(boom.status_code).to eq 503
        expect(boom.raw_body).to eq "A non JSON response"
      end
    end

    context "when symbolize_keys is true" do
      it "sets title and detail on the error params" do
        response_values = {:status => 422, :headers => {}, :body => '{"title": "foo", "detail": "bar"}'}
        exception = Faraday::Error::ClientError.new("the server responded with status 422", response_values)
        api_request = PDRC::APIRequest.new(builder: PDRC::Request.new(symbolize_keys: true))
        begin
          api_request.send(:handle_error, exception)
        rescue => boom
          expect(boom.title).to eq "foo"
          expect(boom.detail).to eq "bar"
        end
      end
    end
  end
end
