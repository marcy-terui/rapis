require 'spec_helper'

describe Rapis::Converter do
  let(:converter) do
    Rapis::Converter.new
  end

  let(:rb_data) do
    File.read(File.dirname(__FILE__) + '/Apifile')
  end

  let(:hash_data) do
    JSON.parse(File.read(File.dirname(__FILE__) + '/Apifile.json'))
  end

  describe '#to_h' do
    it 'should be a hash' do
      expect(converter.to_h(rb_data)).to eq hash_data
    end
  end

  describe '#to_dsl' do
    it 'should be a Ruby DSL' do
      expect(converter.to_dsl(hash_data)).to eq rb_data
    end
  end
end
