module Rapis
  class Converter
    include Rapis::TemplateFunctions

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
        case k
        when %r{^\/}
          item_key_proc k
        when /^\d{3}$/
          code_key_proc k
        when 'parameters', 'api_key'
          parameters_key_proc k
        when /^(response|request)Parameters$/
          integration_parameters_key_proc k
        else
          CHANGE_SETS.each { |f, t| k = k.gsub(f, t) }
          k
        end
      end
    end

    def integration_parameters_key_proc(k)
      proc do |v, nested|
        indents = v.match(/\n(\s+)/)
        if v =~ /\n(\s+)/
          indent = $1
          v = instance_eval(v)
          dsl = "#{k} do\n"
          params = {}
          convert = true
          v.each do |k1, v1|
            if k1 =~ /^(.+\..+\..+)\.(.+)$/
              params[$1] = {} unless params.has_key?($1)
              params[$1][$2] = v1
            else
              convert = false
            end
          end
          if convert
            params.each do |prefix, hash|
              dsl << indent + "#{prefix.gsub('.', '_')}(\n"
              dsl << indent + "  #{hash.pretty_inspect.strip.gsub("\n", "\n" + indent)})\n"
            end
            dsl << indent[2..-1] + "end\n"
          else
            "#{k} #{v}"
          end
        else
          "#{k} #{v}"
        end
      end
    end

    def item_key_proc(k)
      proc do |v, nested|
        if nested
          "item #{k.inspect} #{v}"
        else
          "item #{k.inspect}, #{v}"
        end
      end
    end

    def code_key_proc(k)
      proc do |v, nested|
        if nested
          "code #{k.to_s.inspect} #{v}"
        else
          "code #{k.to_s.inspect}, #{v}"
        end
      end
    end

    def parameters_key_proc(k)
      proc do |v, nested|
        if v =~ /\n(\s+)/
          indent = $1
          v = instance_eval(v)
          dsl = "#{k} do\n"
          if v.is_a?(Array)
            v.each do |param|
              dsl << param_to_dsl(param, indent)
            end
          else
            dsl << param_to_dsl(v, indent)
          end
          dsl << indent[2..-1] + "end\n"
        else
          "#{k} #{v}"
        end
      end
    end

    def param_to_dsl(param, indent)
      dsl = indent + "#{param['in']} #{param['name'].inspect} do\n"
      param.each do |pk, pv|
        next if %w(in name).include?(pk)
        dsl << indent
        dsl += pv.is_a?(String) ? "  #{pk} #{pv.inspect}\n" : "  #{pk} #{pv}\n"
      end
      dsl << indent + "end\n"
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
        when Hash, Array, TrueClass, FalseClass
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
        #{template_code_func}
        #{template_item_func}
        #{template_api_key_func}
        #{template_params_func}
        EOS
    end
  end
end
