require 'json'

module Rapis
  class Utils
    def self.struct_to_hash(val)
      val = val.to_h if val.is_a?(Struct)
      val = Hash[val.map { |k,v| [k,struct_to_hash(v)] }] if val.is_a?(Hash)
      val = val.map! { |v| struct_to_hash(v) } if val.is_a?(Array)
      val
    end
  end
end
