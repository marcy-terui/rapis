# Rapis

[![Gem Version](https://badge.fury.io/rb/rapis.svg)](https://badge.fury.io/rb/rapis)
[![Build Status](https://travis-ci.org/marcy-terui/rapis.svg?branch=master)](https://travis-ci.org/marcy-terui/rapis)
[![Coverage Status](https://coveralls.io/repos/github/marcy-terui/rapis/badge.svg?branch=master)](https://coveralls.io/github/marcy-terui/rapis?branch=master)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/marcy-terui/rapis/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/marcy-terui/rapis/?branch=master)


Swagger as Ruby DSL and its deployment tool for Amazon API Gateway

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rapis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rapis

## Usage

```sh
Commands:
  rapis apply -r, --rest-api=REST_API                     # Apply the REST API configuration
  rapis convert -F, --format=FORMAT                       # Convert the REST API configuration to the specified format
  rapis create -n, --name=NAME                            # Create REST API
  rapis deploy -r, --rest-api=REST_API -s, --stage=STAGE  # Deploy the current REST API configuration to the stage
  rapis diff -r, --rest-api=REST_API -s, --stage=STAGE    # Diff the local configuration and the remote configuration
  rapis export -r, --rest-api=REST_API -s, --stage=STAGE  # Export the configuration as Ruby DSL
  rapis help [COMMAND]                                    # Describe available commands or one specific command
  rapis list                                              # List the REST APIs and the stages

Options:
  -f, [--file=FILE]  # Configuration file
                     # Default: Apifile
```

## Commands

### create
Create REST API

```sh
Usage:
  rapis create -n, --name=NAME

Options:
  -n, --name=NAME                  # Name
  -d, [--description=DESCRIPTION]  # Description
  -f, [--file=FILE]                # Configuration file
                                   # Default: Apifile
```

### apply
Apply the REST API configuration

```sh
Usage:
  rapis apply -r, --rest-api=REST_API

Options:
  -r, --rest-api=REST_API  # The id of the REST API
  -f, [--file=FILE]        # Configuration file
                           # Default: Apifile
```

### convert
Convert the REST API configuration to the specified format

```sh
Usage:
  rapis convert -F, --format=FORMAT

Options:
  -F, --format=FORMAT    # Output format # accepts json, yaml
  -o, [--output=OUTPUT]  # Output path
  -f, [--file=FILE]      # Configuration file
                         # Default: Apifile

```

### deploy
Deploy the current REST API configuration to the stage

```sh
Usage:
  rapis deploy -r, --rest-api=REST_API -s, --stage=STAGE

Options:
  -r, --rest-api=REST_API                      # The id of the REST API
  -s, --stage=STAGE                            # The name of the stage
  -d, [--description=DESCRIPTION]              # The description for the deployment
  -D, [--stage-description=STAGE_DESCRIPTION]  # The description of the stage
  -c, [--cache=CACHE]                          # Size of the cache cluster
                                               # Default: 0.0
  -v, [--variables=key:value]                  # A map that defines the stage variables
  -f, [--file=FILE]                            # Configuration file
                                               # Default: Apifile
```

### export
Export the configuration as Ruby DSL

```sh
Usage:
  rapis export -r, --rest-api=REST_API -s, --stage=STAGE

Options:
  -r, --rest-api=REST_API      # The id of the REST API
  -s, --stage=STAGE            # The name of the stage
  -w, [--write], [--no-write]  # Write the configuration to the file
  -f, [--file=FILE]            # Configuration file
                               # Default: Apifile
```

### List
List the REST APIs and the stages

```sh
Usage:
  rapis list

Options:
  -V, [--verbose], [--no-verbose]  # Verbose mode
  -f, [--file=FILE]                # Configuration file
                                   # Default: Apifile
```

### diff
Diff the local configuration and the remote configuration

```sh
Usage:
  rapis diff -r, --rest-api=REST_API -s, --stage=STAGE

Options:
  -r, --rest-api=REST_API  # The id of the REST API
  -s, --stage=STAGE        # The name of the stage
  -f, [--file=FILE]        # Configuration file
                           # Default: Apifile
```

## Example

### Ruby DSL

- Apifile

```ruby
rest_api do
  swagger "2.0"
  info do
    version "2016-05-27T17:07:04Z"
    title "PetStore"
  end
  host "p0dvujrb13.execute-api.ap-northeast-1.amazonaws.com"
  basePath "/test"
  schemes ["https"]
  _include 'paths.rb'
  _include 'definitions.rb'
end
```

- paths.rb

```ruby
paths do
  item "/pets/{petId}" do
    get do
      produces ["application/json"]
      parameters do
        path "petId" do
          required true
          type "string"
        end
      end
      responses do
        code "200" do
          description "200 response"
          schema do
            ref "#/definitions/Empty"
          end
          headers(
            {"Access-Control-Allow-Origin"=>{"type"=>"string"}})
        end
      end
      amazon_apigateway_integration do
        responses do
          default do
            statusCode 200
            responseParameters(
              {"method.response.header.Access-Control-Allow-Origin"=>"'*'"})
          end
        end
        uri "http://petstore-demo-endpoint.execute-api.com/petstore/pets/{petId}"
        passthroughBehavior "when_no_match"
        httpMethod "GET"
        requestParameters(
          {"integration.request.path.petId"=>"method.request.path.petId"})
        type "http"
      end
    end
    options do
      consumes ["application/json"]
      produces ["application/json"]
      responses do
        code "200" do
          description "200 response"
          schema do
            ref "#/definitions/Empty"
          end
          headers(
            {"Access-Control-Allow-Origin"=>{"type"=>"string"},
             "Access-Control-Allow-Methods"=>{"type"=>"string"},
             "Access-Control-Allow-Headers"=>{"type"=>"string"}})
        end
      end
      amazon_apigateway_integration do
        responses do
          default do
            statusCode 200
            responseParameters(
              {"method.response.header.Access-Control-Allow-Methods"=>"'GET,OPTIONS'",
               "method.response.header.Access-Control-Allow-Headers"=>
                "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'",
               "method.response.header.Access-Control-Allow-Origin"=>"'*'"})
          end
        end
        requestTemplates(
          {"application/json"=>"{\"statusCode\": 200}"})
        passthroughBehavior "when_no_match"
        type "mock"
      end
    end
  end
end
```

- definitions.rb

```ruby
definitions do
  Empty do
    type "object"
  end
end
```

### JSON result

```json
{
  "swagger": "2.0",
  "info": {
    "version": "2016-05-27T17:07:04Z",
    "title": "PetStore"
  },
  "host": "p0dvujrb13.execute-api.ap-northeast-1.amazonaws.com",
  "basePath": "/test",
  "schemes": [
    "https"
  ],
  "paths": {
    "/pets/{petId}": {
      "get": {
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "name": "petId",
            "in": "path",
            "required": true,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "200 response",
            "schema": {
              "$ref": "#/definitions/Empty"
            },
            "headers": {
              "Access-Control-Allow-Origin": {
                "type": "string"
              }
            }
          }
        },
        "x-amazon-apigateway-integration": {
          "responses": {
            "default": {
              "statusCode": "200",
              "responseParameters": {
                "method.response.header.Access-Control-Allow-Origin": "'*'"
              }
            }
          },
          "uri": "http://petstore-demo-endpoint.execute-api.com/petstore/pets/{petId}",
          "passthroughBehavior": "when_no_match",
          "httpMethod": "GET",
          "requestParameters": {
            "integration.request.path.petId": "method.request.path.petId"
          },
          "type": "http"
        }
      },
      "options": {
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "responses": {
          "200": {
            "description": "200 response",
            "schema": {
              "$ref": "#/definitions/Empty"
            },
            "headers": {
              "Access-Control-Allow-Origin": {
                "type": "string"
              },
              "Access-Control-Allow-Methods": {
                "type": "string"
              },
              "Access-Control-Allow-Headers": {
                "type": "string"
              }
            }
          }
        },
        "x-amazon-apigateway-integration": {
          "responses": {
            "default": {
              "statusCode": "200",
              "responseParameters": {
                "method.response.header.Access-Control-Allow-Methods": "'GET,OPTIONS'",
                "method.response.header.Access-Control-Allow-Headers": "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'",
                "method.response.header.Access-Control-Allow-Origin": "'*'"
              }
            }
          },
          "requestTemplates": {
            "application/json": "{\"statusCode\": 200}"
          },
          "passthroughBehavior": "when_no_match",
          "type": "mock"
        }
      }
    }
  },
  "definitions": {
    "Empty": {
      "type": "object"
    }
  }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcy-terui/rapis.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
