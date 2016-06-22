require 'spec_helper'

describe Rapis::Converter do
  let(:converter) do
    Rapis::Converter.new
  end

  let(:rb_data) do
    File.read(File.expand_path(File.dirname(__FILE__)) + '/_files/Apifile')
  end

  let(:rb_data_from_json) do
    File.read(File.expand_path(File.dirname(__FILE__)) + '/_files/Apifile_from_json')
  end

  let(:hash_data) do
    JSON.parse(File.read(File.expand_path(File.dirname(__FILE__)) + '/_files/Apifile.json'))
  end

  describe '#to_h' do
    it 'should be a hash' do
      expect(converter.to_h(rb_data)).to eq hash_data
    end
  end

  describe '#to_dsl' do
    it 'should be a Ruby DSL' do
      expect(converter.to_dsl(hash_data)).to eq rb_data_from_json
    end
  end
end
