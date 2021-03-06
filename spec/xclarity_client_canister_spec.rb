require 'spec_helper'

describe XClarityClient do

  before :all do
    WebMock.allow_net_connect! # -- Uncomment this line if you're using a external connection or mock.

    conf = XClarityClient::Configuration.new(
    :username => ENV['LXCA_USERNAME'],
    :password => ENV['LXCA_PASSWORD'],
    :host     => ENV['LXCA_HOST'],
    :port     => ENV['LXCA_PORT'],
    :auth_type => ENV['LXCA_AUTH_TYPE'],
    :verify_ssl => ENV['LXCA_VERIFY_SSL']
    )

    @client = XClarityClient::Client.new(conf)
  end

  before :each do
    @includeAttributes = %w(memorySlots)
    @excludeAttributes = %w(memorySlots)
    @uuidArray = @client.discover_canisters.map { |canister| canister.uuid  }
  end

  it 'has a version number' do
    expect(XClarityClient::VERSION).not_to be nil
  end

  describe 'GET /canisters' do

    it 'should respond with an array' do
      expect(@client.discover_canisters.class).to eq(Array)
    end
    
    context 'with includeAttributes' do
      it 'include attributes should not be nil' do
        response = @client.fetch_canisters(nil,@includeAttributes,nil)
        response.map do |canister|
          @includeAttributes.map do |attribute|
            expect(canister.send(attribute)).not_to be_nil
          end
        end
      end
    end

    context 'with excludeAttributes' do
      it 'exclude attributes should be nil' do
        response = @client.fetch_canisters(nil,nil,@excludeAttributes)
        response.map do |canister|
          @excludeAttributes.map do |attribute|
            expect(canister.send(attribute)).to be_nil
          end
        end
      end
    end

  end

  describe 'GET /canisters/UUID' do

    context 'with includeAttributes' do
      it 'include attributes should not be nil' do
        response = @client.fetch_canisters(@uuidArray, @includeAttributes,nil)
        response.map do |canister|
          @includeAttributes.map do |attribute|
          expect(canister.send(attribute)).not_to be_nil
          end
        end
      end
    end

    context 'with excludeAttributes' do
      it 'exclude attributes should be nil' do
        response = @client.fetch_canisters(@uuidArray, nil, @excludeAttributes)
        response.map do |canister|
          @excludeAttributes.map do |attribute|
          expect(canister.send(attribute)).to be_nil
          end
        end
      end
    end
  end
end
