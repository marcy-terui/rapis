require 'spec_helper'

describe Rapis::Utils do
  describe '#struct_to_hash' do
    it 'should be a hash' do
      expect(
        Rapis::Utils.struct_to_hash(
          [OpenStruct.new(
            foo: 'bar',
            buz: OpenStruct.new(foo2: 'bar2')
          )]
        )
      ).to eq(
        [{
          'foo' => 'bar',
          'buz' => { 'foo2' => 'bar2' }
        }]
      )
    end
  end

  describe '#diff' do
    it 'should be a text of difference' do
      hash1 = { foo: 'bar' }
      hash2 = { buz: 'qux' }
      expect(Rapis::Utils.diff(hash1, hash2)).to include('+')
    end
  end

  describe '#print_yaml' do
    it 'should output a YAML' do
      yaml = <<-EOS
---
foo:
  - bar: buz
EOS
      expect { Rapis::Utils.print_yaml(yaml) }.not_to raise_error
    end
  end

  describe '#print_json' do
    it 'should output a JSON' do
      expect { Rapis::Utils.print_json('{"foo": "bar"}') }.not_to raise_error
    end
  end

  describe '#print_ruby' do
    it 'should output a Ruby DSL' do
      ruby = <<-EOS
rest_api do
  foo 'bar'
end
EOS
      expect { Rapis::Utils.print_ruby(ruby) }.not_to raise_error
    end
  end
end
