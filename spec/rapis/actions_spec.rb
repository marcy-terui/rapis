require 'spec_helper'

describe Rapis::Actions do
  let(:client) do
    double('client')
  end

  let(:input_file) do
    File.dirname(__FILE__) + '/Apifile.in'
  end

  let(:output_file) do
    File.dirname(__FILE__) + '/Apifile.out'
  end

  let(:test_file_data) do
    {
      'swagger' => '2.0',
      'info' => {
        'title' => 'PetStore'
      }
    }
  end

  let(:test_file_text) do
    <<-EOS
rest_api do
  swagger "2.0"
  info do
    title "PetStore"
  end
end
    EOS
  end

  before do
    File.write(input_file, test_file_text) unless File.exist?(input_file)
  end

  after do
    File.delete(output_file) if File.exist?(output_file)
    File.delete(input_file) if File.exist?(input_file)
  end

  describe '#create' do
    it 'should be successful' do
      allow(client).to receive(:create).and_return(
        OpenStruct.new(
          id: 'id',
          name: 'name',
          description: 'description',
          warnings: %w(foo bar buz)
        )
      )
      actions = Rapis::Actions.new(client)
      expect do
        actions.create('name' => 'name', 'description' => 'description')
      end.not_to raise_error
    end
  end

  describe '#convert' do
    it 'should output a YAML' do
      actions = Rapis::Actions.new(client)
      actions.convert(
        'format' => 'yaml',
        'file' => input_file,
        'output' => output_file
      )
      expect(YAML.load(File.read(output_file))).to eq test_file_data
    end

    it 'should output a JSON' do
      actions = Rapis::Actions.new(client)
      actions.convert(
        'format' => 'json',
        'file' => input_file,
        'output' => output_file
      )
      expect(JSON.load(File.read(output_file))).to eq test_file_data
    end

    it 'should raise error' do
      actions = Rapis::Actions.new(client)
      expect do
        actions.convert(
          'format' => 'foo',
          'file' => input_file,
          'output' => output_file
        )
      end.to raise_error OperationError
    end
  end

  describe '#list' do
    before do
      allow(client).to receive(:get_apis).and_return([OpenStruct.new(
        id: 'id',
        name: 'name'
      )])
      allow(client).to receive(:get_stages).and_return([OpenStruct.new(
        stage_name: 'stage_name',
        stage_description: 'stage_description'
      )])
    end

    context 'is not verbose' do
      it 'should be a simple API list' do
        actions = Rapis::Actions.new(client)
        expect(actions.list('verbose' => false)).to eq [{
          'id (name)' => ['stage_name']
        }]
      end
    end

    context 'is verbose' do
      it 'should be a verbose API list' do
        actions = Rapis::Actions.new(client)
        expect(actions.list('verbose' => true)).to eq(
          [{
            'id' => 'id',
            'name' => 'name',
            'stages' => [{
              'stage_name' => 'stage_name',
              'stage_description' => 'stage_description'
            }]
          }]
        )
      end
    end
  end

  describe '#export' do
    it 'should output a Ruby DSL' do
      allow(client).to receive(:export_api).and_return(test_file_data)
      actions = Rapis::Actions.new(client)
      actions.export(
        'rest_api' => 'rest_api',
        'stage' => 'stage',
        'file' => output_file,
        'write' => true
      )
      expect(File.read(output_file)).to eq test_file_text
    end
  end

  describe '#diff' do
    it 'should be successful' do
      allow(client).to receive(:export_api).and_return(test_file_data)
      actions = Rapis::Actions.new(client)
      expect do
        actions.diff(
          'rest_api' => 'rest_api',
          'stage' => 'stage',
          'file' => input_file
        )
      end.not_to raise_error
    end
  end

  describe '#apply' do
    it 'should be successful' do
      allow(client).to receive(:put_api).and_return(
        OpenStruct.new(
          id: 'id',
          name: 'name',
          warnings: %w(foo bar buz)
        )
      )
      actions = Rapis::Actions.new(client)
      expect do
        actions.apply('rest_api' => 'rest_api', 'file' => input_file)
      end.not_to raise_error
    end
  end

  describe '#deploy' do
    it 'should be successful' do
      allow(client).to receive(:deploy).and_return(
        OpenStruct.new(
          id: 'id',
          description: 'description',
          summary: OpenStruct.new(
            foo: 'foo',
            bar: 'bar'
          )
        )
      )
      actions = Rapis::Actions.new(client)
      expect do
        actions.deploy(
          'rest_api' => 'rest_api',
          'stage' => 'stage',
          'description' => 'description',
          'stage_description' => 'stage_description',
          'cache' => '1.6',
          'variables' => {
            'foo' => 'bar'
          }
        )
      end.not_to raise_error
    end
  end
end
