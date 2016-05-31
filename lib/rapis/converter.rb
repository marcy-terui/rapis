module Rapis
  class Converter
    CHANGE_SETS = {
      'x-amazon-apigateway-integration' => 'amazon_apigateway_integration',
      '$ref' => 'ref'
    }

    def to_dsl(hash)
      dsl = Dslh.deval(
        hash,
        exclude_key: to_dsl_exclude_key,
        key_conv: to_dsl_key_conv,
        value_conv: to_dsl_value_conv
      )
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

    def to_dsl_exclude_key
      proc do |k|
        if !k.is_a?(String)
          false
        elsif ['in'].include?(k)
          true
        elsif k.include?('/')
          if k =~ %r{^\/}
            false
          else
            true
          end
        elsif ['-', '.'].any? { |i| k.include?(i) } && k != 'x-amazon-apigateway-integration'
          true
        else
          false
        end
      end
    end

    def to_dsl_key_conv
      proc do |k|
        k = k.to_s
        if k =~ %r{^\/}
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
          CHANGE_SETS.each { |f, t| k = k.gsub(f, t) }
          k
        end
      end
    end

    def to_dsl_value_conv
      proc do |v|
        if v.is_a?(String) && v =~ /\A(?:0|[1-9]\d*)\Z/
          v.to_i
        else
          v
        end
      end
    end

    def to_h_exclude_key
      proc do |_|
        false
      end
    end

    def to_h_key_conv
      proc do |k|
        k = k.to_s
        CHANGE_SETS.each { |f, t| k = k.gsub(t, f) }
        k
      end
    end

    def to_h_value_conv
      proc do |v|
        case v
        when Hash, Array
          v
        else
          v.to_s
        end
      end
    end

    def rest_api(&block)
      @apis = Dslh.eval(
        exclude_key: to_h_exclude_key,
        key_conv: to_h_key_conv,
        value_conv: to_h_value_conv,
        allow_empty_args: true,
        scope_hook: proc { |scope| define_template_func(scope) },
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
