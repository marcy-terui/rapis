module Rapis
  class Utils
    class << self
      def struct_to_hash(val)
        val = val.to_h if val.is_a?(Struct) || val.is_a?(OpenStruct)
        val = val.to_s if val.is_a?(Symbol)
        val = Hash[val.map { |k, v| [k.to_s, struct_to_hash(v)] }] if val.is_a?(Hash)
        val = val.map! { |v| struct_to_hash(v) } if val.is_a?(Array)
        val
      end

      def diff(hash1, hash2)
        Diffy::Diff.new(
          JSON.pretty_generate(hash1),
          JSON.pretty_generate(hash2),
          diff: '-u'
        ).to_s(:color)
      end

      def print_yaml(yaml)
        CodeRay::Encoders::Terminal::TOKEN_COLORS[:key] = {
          self: "\e[32m"
        }
        puts CodeRay.scan(yaml, :yaml).terminal
      end

      def print_ruby(ruby)
        puts CodeRay.scan(ruby, :ruby).terminal
      end

      def print_json(json)
        puts CodeRay.scan(json, :json).terminal
      end
    end
  end
end
