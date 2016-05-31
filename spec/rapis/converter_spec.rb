require 'spec_helper'

describe Rapis::Converter do
  let(:converter) do
    Rapis::Converter.new
  end

  let(:rb_data) do
    File.read(File.dirname(__FILE__) + '/Apifile')
  end

  let(:hash_data) do
    {
      'swagger' => '2.0',
      'info' => {
        'version' => '2016-05-27T17:07:04Z',
        'title' => 'PetStore'
      },
      'host' => 'p0dvujrb13.execute-api.ap-northeast-1.amazonaws.com',
      'basePath' => '/test',
      'schemes' => [
        'https'
      ],
      'paths' => {
        '/' => {
          'get' => {
            'consumes' => [
              'application/json'
            ],
            'produces' => [
              'text/html'
            ],
            'responses' => {
              200 => {
                'description' => '200 response',
                'headers' => {
                  'Content-Type' => {
                    'type' => 'string'
                  }
                }
              }
            },
            'x-amazon-apigateway-integration' => {
              'type' => 'mock',
              'responses' => {
                'default' => {
                  'statusCode' => '200',
                  'responseParameters' => {
                    'method.response.header.Content-Type' => "'text/html'"
                  },
                  'responseTemplates' => {
                    'text/html' => '<html></html>'
                  }
                }
              },
              'requestTemplates' => {
                'application/json' => '{"statusCode": 200}'
              },
              'passthroughBehavior' => 'when_no_match'
            }
          }
        }
      },
      'definitions' => {
        'Empty' => {
          'type' => 'object'
        }
      }
    }
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
