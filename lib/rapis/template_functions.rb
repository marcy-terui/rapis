module Rapis
  module TemplateFunctions
    def template_params
      %w(query header path formData body)
    end

    def template_params_func
      funcs = <<-EOS
      def _param(name, i, block)
        @__hash__['parameters'] << {
          'name' => name,
          'in' => i
        }.merge(Dslh::ScopeBlock.nest(binding, 'block', name))
      end
      EOS
      template_params.each do |i|
        funcs << <<-EOS
          def #{i}(name, value = nil, &block)
            _param(name, #{i.inspect}, block)
          end
        EOS
      end
      <<-EOS
      def parameters(value = nil, &block)
        if value.nil?
          @__hash__['parameters'] = []

          #{funcs}

          if block
            value = instance_eval(&block)
          end
        else
          @__hash__['parameters'] = value
        end
      end
      EOS
    end

    def template_api_key_func
      funcs = <<-EOS
      def _api_key(name, i, block)
        @__hash__['api_key'] = Dslh::ScopeBlock.nest(binding, 'block', name).merge({
          'name' => name,
          'in' => i
        })
      end
      EOS
      template_params.each do |i|
        funcs << <<-EOS
          def #{i}(name, value = nil, &block)
            _api_key(name, #{i.inspect}, block)
          end
        EOS
      end
      <<-EOS
      def api_key(value = nil, &block)
        if value.nil?
          @__hash__['api_key'] = []

          #{funcs}

          if block
            value = instance_eval(&block)
          end
        else
          @__hash__['api_key'] = value
        end
      end
      EOS
    end

    def template_item_func
      <<-EOS
      def item(key, value = nil, &block)
        if block
          value = Dslh::ScopeBlock.nest(binding, 'block', key)
        end
        @__hash__[key] = value
      end
      EOS
    end

    def template_code_func
      <<-EOS
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
