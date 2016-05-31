require 'spec_helper'

describe Rapis::Client do
  let(:client) do
    Rapis::Client.new
  end

  let(:api) do
    double('api')
  end

  describe '#create' do
    it 'should be successful' do
      result = { result: 'result' }
      allow(api).to receive(:create_rest_api).and_return(result)
      allow(client).to receive(:api).and_return(api)
      expect(client.create('name', 'desc')).to eq result
    end
  end

  describe '#get_apis' do
    it 'should be an array' do
      allow(api).to receive(:get_rest_apis).and_return(
        OpenStruct.new(
          items: %w(foo bar),
          position: nil
        )
      )
      allow(client).to receive(:api).and_return(api)
      expect(client.get_apis).to eq %w(foo bar)
    end
  end

  describe '#get_stages' do
    it 'should be an array' do
      allow(api).to receive(:get_stages).and_return(
        OpenStruct.new(
          item: %w(foo bar)
        )
      )
      allow(client).to receive(:api).and_return(api)
      expect(client.get_stages('api_id')).to eq %w(foo bar)
    end
  end

  describe '#export_api' do
    it 'should be an hash' do
      allow(api).to receive(:get_export).and_return(
        OpenStruct.new(
          body: OpenStruct.new(
            read: '{"foo": "bar"}'
          )
        )
      )
      allow(client).to receive(:api).and_return(api)
      expect(client.export_api('api_id', 'stage_name')).to eq('foo' => 'bar')
    end
  end

  describe '#put_api' do
    it 'should be successful' do
      result = { result: 'result' }
      allow(api).to receive(:put_rest_api).and_return(result)
      allow(client).to receive(:api).and_return(api)
      expect(client.put_api('api_id', foo: 'bar')).to eq result
    end
  end

  describe '#deploy' do
    it 'should be successful' do
      result = { result: 'result' }
      allow(api).to receive(:create_deployment).and_return(result)
      allow(client).to receive(:api).and_return(api)
      expect(client.deploy(foo: 'bar')).to eq result
    end
  end\
end
