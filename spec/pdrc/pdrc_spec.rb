require 'spec_helper'
require 'cgi'

describe PDRC do
  describe "attributes" do
    before do
      PDRC::APIRequest.send(:public, *PDRC::APIRequest.protected_instance_methods)

      @api_key = "y_NbAkKc66ryYTWUXYEu"
      @proxy = 'the_proxy'
    end

    it "have no API by default" do
      @pdrc = PDRC::Request.new
      expect(@pdrc.api_key).to be_nil
    end
    it "sets an API key in the constructor" do
      @pdrc = PDRC::Request.new(api_key: @api_key)
      expect(@pdrc.api_key).to eq(@api_key)
    end

    it "sets an API key from the 'PAGERDUTY_API_KEY' ENV variable" do
      ENV['PAGERDUTY_API_KEY'] = @api_key
      @pdrc = PDRC::Request.new
      expect(@pdrc.api_key).to eq(@api_key)
      ENV.delete('PAGERDUTY_API_KEY')
    end

    it "sets an API key via setter" do
      @pdrc = PDRC::Request.new
      @pdrc.api_key = @api_key
      expect(@pdrc.api_key).to eq(@api_key)
    end

    it "sets timeout and get" do
      @pdrc = PDRC::Request.new
      timeout = 30
      @pdrc.timeout = timeout
      expect(timeout).to eq(@pdrc.timeout)
    end

    it "sets the open_timeout and get" do
      @pdrc = PDRC::Request.new
      open_timeout = 30
      @pdrc.open_timeout = open_timeout
      expect(open_timeout).to eq(@pdrc.open_timeout)
    end

    it "timeout properly passed to APIRequest" do
      @pdrc = PDRC::Request.new
      timeout = 30
      @pdrc.timeout = timeout
      @request = PDRC::APIRequest.new(builder: @pdrc)
      expect(timeout).to eq(@request.timeout)
    end

    it "timeout properly based on open_timeout passed to APIRequest" do
      @pdrc = PDRC::Request.new
      open_timeout = 30
      @pdrc.open_timeout = open_timeout
      @request = PDRC::APIRequest.new(builder: @pdrc)
      expect(open_timeout).to eq(@request.open_timeout)
    end

    it "detect api endpoint from initializer parameters" do
      api_endpoint = 'https://api.pagerduty.com'
      @pdrc = PDRC::Request.new(api_key: @api_key, api_endpoint: api_endpoint)
      expect(api_endpoint).to eq(@pdrc.api_endpoint)
    end

    it "has no Proxy url by default" do
      @pdrc = PDRC::Request.new
      expect(@pdrc.proxy).to be_nil
    end

    it "sets an proxy url key from the 'PAGERDUTY_PROXY_URL' ENV variable" do
      ENV['PAGERDUTY_PROXY'] = @proxy
      @pdrc = PDRC::Request.new
      expect(@pdrc.proxy).to eq(@proxy)
      ENV.delete('PAGERDUTY_PROXY')
    end

    it "sets an API key via setter" do
      @pdrc = PDRC::Request.new
      @pdrc.proxy = @proxy
      expect(@pdrc.proxy).to eq(@proxy)
    end

    it "sets an adapter in the constructor" do
      adapter = :em_synchrony
      @pdrc = PDRC::Request.new(faraday_adapter: adapter)
      expect(@pdrc.faraday_adapter).to eq(adapter)
    end

    it "symbolize_keys false by default" do
      @pdrc = PDRC::Request.new
      expect(@pdrc.symbolize_keys).to be false
    end

    it "sets symbolize_keys in the constructor" do
      @pdrc = PDRC::Request.new(symbolize_keys: true)
      expect(@pdrc.symbolize_keys).to be true
    end

    it "sets symbolize_keys in the constructor" do
      @pdrc = PDRC::Request.new(symbolize_keys: true)
      expect(@pdrc.symbolize_keys).to be true
    end
    it "debug false by default" do
      @pdrc = PDRC::Request.new
      expect(@pdrc.debug).to be false
    end

    it "sets debug in the constructor" do
      @pdrc = PDRC::Request.new(debug: true)
      expect(@pdrc.debug).to be true
    end

    it "sets logger in constructor" do
      logger = double(:logger)
      @pdrc = PDRC::Request.new(logger: logger)
      expect(@pdrc.logger).to eq(logger)
    end

    it "is a Logger instance by default" do
      @pdrc = PDRC::Request.new
      expect(@pdrc.logger).to be_a Logger
    end

  end

  describe "class variables" do
    let(:logger) { double(:logger) }

    before do
      PDRC::Request.api_key = "XFZ8MisS7d9IytnVniqS"
      PDRC::Request.timeout = 15
      PDRC::Request.api_endpoint = 'https://api.pagerduty.com'
      PDRC::Request.logger = logger
      PDRC::Request.proxy = "http://1234.com"
      PDRC::Request.symbolize_keys = true
      PDRC::Request.faraday_adapter = :net_http
      PDRC::Request.debug = true
    end

    after do
      PDRC::Request.api_key = nil
      PDRC::Request.timeout = nil
      PDRC::Request.api_endpoint = nil
      PDRC::Request.logger = nil
      PDRC::Request.proxy = nil
      PDRC::Request.symbolize_keys = nil
      PDRC::Request.faraday_adapter = nil
      PDRC::Request.debug = nil
    end

    it "set api key on new instances" do
      expect(PDRC::Request.new.api_key).to eq(PDRC::Request.api_key)
    end

    it "set timeout on new instances" do
      expect(PDRC::Request.new.timeout).to eq(PDRC::Request.timeout)
    end

    it "set api_endpoint on new instances" do
      expect(PDRC::Request.api_endpoint).not_to be_nil
      expect(PDRC::Request.new.api_endpoint).to eq(PDRC::Request.api_endpoint)
    end

    it "set proxy on new instances" do
      expect(PDRC::Request.new.proxy).to eq(PDRC::Request.proxy)
    end

    it "set symbolize_keys on new instances" do
      expect(PDRC::Request.new.symbolize_keys).to eq(PDRC::Request.symbolize_keys)
    end

    it "set debug on new instances" do
      expect(PDRC::Request.new.debug).to eq(PDRC::Request.debug)
    end

    it "set faraday_adapter on new instances" do
      expect(PDRC::Request.new.faraday_adapter).to eq(PDRC::Request.faraday_adapter)
    end

    it "set logger on new instances" do
      expect(PDRC::Request.new.logger).to eq(logger)
    end
  end

  describe "missing methods" do
    it "respond to .method call on class" do
      expect(PDRC::Request.method(:teams)).to be_a(Method)
    end
    it "respond to .method call on instance" do
      expect(PDRC::Request.new.method(:teams)).to be_a(Method)
    end
  end

  describe 'path building using method missing invocations' do
    it 'constructs a path' do
      expect(PDRC::Request.teams.path).to eq "teams"
    end

    it 'expands the paths over multiple invocations' do
      expect(PDRC::Request.teams.users.path).to eq "teams/users"
    end

    it 'includes ids passed in as arguments' do
      expect(PDRC::Request.teams("1234MYTEAM").path).to eq "teams/1234MYTEAM"
    end

    it 'expands multiple paths with arguments' do
      expect(PDRC::Request.teams("1234-team").users("4321").path).to eq "teams/1234-team/users/4321"
    end
  end
end
