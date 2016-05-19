require 'json'
require 'diffy'
require 'coderay'

module Rapis
  class Utils
    def self.struct_to_hash(val)
      val = val.to_h if val.kind_of?(Struct)
      val = val.to_s if val.kind_of?(Symbol)
      val = Hash[val.map { |k,v| [k.to_s,struct_to_hash(v)] }] if val.kind_of?(Hash)
      val = val.map! { |v| struct_to_hash(v) } if val.kind_of?(Array)
      val
    end

    def self.diff(hash1, hash2, opts={})
      Diffy::Diff.new(
        JSON.pretty_generate(hash1),
        JSON.pretty_generate(hash2),
        :diff => '-u'
      ).to_s(:color)
    end

    def self.print_yaml(yaml)
      CodeRay::Encoders::Terminal::TOKEN_COLORS[:key] = {
        self: "\e[32m",
      }
      puts CodeRay.scan(yaml, :yaml).terminal
    end

    def self.print_ruby(ruby)
      puts CodeRay.scan(ruby, :ruby).terminal
    end

    def self.print_json(json)
      puts CodeRay.scan(json, :json).terminal
    end
  end
end
