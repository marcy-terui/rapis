require 'dslh'
require 'rapis/utils'
require 'pp'

CHANGE_SETS = {
  'x-amazon-apigateway-integration' => 'amazon_apigateway_integration',
  '$ref' => 'ref'
}

module Rapis
  class Converter
    def to_dsl(hash)
      exclude_key = proc do |k|
        if ['in'].include?(k)
          true
        elsif (k.include?('/') and not k =~ /^\//)
          true
        elsif ['-', '.'].any? {|i| k.include?(i) } and k != 'x-amazon-apigateway-integration'
          true
        else
          false
        end
      end

      key_conv = proc do |k|
        k = k.to_s
        if k =~ /^\//
          proc do |v, nested|
            if nested
              "path #{k.inspect} #{v}"
            else
              "path #{k.inspect}, #{v}"
            end
          end
        elsif k =~ /^\d{3}$/
          proc do |v, nested|
            if nested
              "code #{k} #{v}"
            else
              "code #{k}, #{v}"
            end
          end
        else
          CHANGE_SETS.each { |f,t| k = k.gsub(f,t) }
          k
        end
      end

      value_conv = proc do |v|
        if v.kind_of?(String) and v =~ /\A(?:0|[1-9]\d*)\Z/
          v.to_i
        else
          v
        end
      end

      dsl = Dslh.deval(
        hash,
        exclude_key: exclude_key,
        key_conv: key_conv,
        value_conv: value_conv)
      dsl.gsub!(/^/, '  ').strip!
<<-EOS
rest_api do
  #{dsl}
end
EOS
    end

    def to_h(dsl)
      instance_eval(dsl)
      @apis
    end

    private

    def rest_api(value = nil, &block)
      exclude_key = proc do |k|
        false
      end

      key_conv = proc do |k|
        k = k.to_s
        CHANGE_SETS.each { |f,t| k = k.gsub(t,f) }
        k
      end

      value_conv = proc do |v|
        case v
        when Hash, Array
          v
        else
          v.to_s
        end
      end

      @apis = Dslh.eval(
        exclude_key: exclude_key,
        key_conv: key_conv,
        value_conv: value_conv,
        allow_empty_args: true,
        scope_hook: proc {|scope| define_template_func(scope)},
        &block
      )
    end

    def define_template_func(scope)
      scope.instance_eval(<<-EOS)
        def path(key, value = nil, &block)
          if block
            value = Dslh::ScopeBlock.nest(binding, 'block', key)
          end
          @__hash__[key] = value
        end
        def code(key, value = nil, &block)
          if block
            value = Dslh::ScopeBlock.nest(binding, 'block', key)
          end
          @__hash__[key] = value
        end
        EOS
    end
  end
end
