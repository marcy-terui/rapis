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

## Sample

### JSON

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
    "/": {
      "get": {
        "consumes": [
          "application/json"
        ],
        "produces": [
          "text/html"
        ],
        "responses": {
          "200": {
            "description": "200 response",
            "headers": {
              "Content-Type": {
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
                "method.response.header.Content-Type": "'text/html'"
              },
              "responseTemplates": {
                "text/html": "<html>\n    <head>\n        <style>\n        body {\n            color: #333;\n            font-family: Sans-serif;\n            max-width: 800px;\n            margin: auto;\n        }\n        </style>\n    </head>\n    <body>\n        <h1>Welcome to your Pet Store API</h1>\n        <p>\n            You have succesfully deployed your first API. You are seeing this HTML page because the <code>GET</code> method to the root resource of your API returns this content as a Mock integration.\n        </p>\n        <p>\n            The Pet Store API contains the <code>/pets</code> and <code>/pets/{petId}</code> resources. By making a <a href=\"/$context.stage/pets/\" target=\"_blank\"><code>GET</code> request</a> to <code>/pets</code> you can retrieve a list of Pets in your API. If you are looking for a specific pet, for example the pet with ID 1, you can make a <a href=\"/$context.stage/pets/1\" target=\"_blank\"><code>GET</code> request</a> to <code>/pets/1</code>.\n        </p>\n        <p>\n            You can use a REST client such as <a href=\"https://www.getpostman.com/\" target=\"_blank\">Postman</a> to test the <code>POST</code> methods in your API to create a new pet. Use the sample body below to send the <code>POST</code> request:\n        </p>\n        <pre>\n{\n    \"type\" : \"cat\",\n    \"price\" : 123.11\n}\n        </pre>\n    </body>\n</html>"
              }
            }
          },
          "requestTemplates": {
            "application/json": "{\"statusCode\": 200}"
          },
          "passthroughBehavior": "when_no_match",
          "type": "mock"
        }
      },
      "post": {
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
          "uri": "http://petstore-demo-endpoint.execute-api.com/petstore/pets",
          "passthroughBehavior": "when_no_match",
          "httpMethod": "POST",
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
                "method.response.header.Access-Control-Allow-Methods": "'POST,OPTIONS'",
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

### Ruby DSL

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
  paths do
    path "/" do
      get do
        consumes ["application/json"]
        produces ["text/html"]
        responses do
          code 200 do
            description "200 response"
            headers(
              {"Content-Type"=>{"type"=>"string"}})
          end
        end
        amazon_apigateway_integration do
          responses do
            default do
              statusCode 200
              responseParameters(
                {"method.response.header.Content-Type"=>"'text/html'"})
              responseTemplates(
                {"text/html"=>
                  "<html>\n    <head>\n        <style>\n        body {\n            color: #333;\n            font-family: Sans-serif;\n            max-width: 800px;\n            margin: auto;\n        }\n        </style>\n    </head>\n    <body>\n        <h1>Welcome to your Pet Store API</h1>\n        <p>\n            You have succesfully deployed your first API. You are seeing this HTML page because the <code>GET</code> method to the root resource of your API returns this content as a Mock integration.\n        </p>\n        <p>\n            The Pet Store API contains the <code>/pets</code> and <code>/pets/{petId}</code> resources. By making a <a href=\"/$context.stage/pets/\" target=\"_blank\"><code>GET</code> request</a> to <code>/pets</code> you can retrieve a list of Pets in your API. If you are looking for a specific pet, for example the pet with ID 1, you can make a <a href=\"/$context.stage/pets/1\" target=\"_blank\"><code>GET</code> request</a> to <code>/pets/1</code>.\n        </p>\n        <p>\n            You can use a REST client such as <a href=\"https://www.getpostman.com/\" target=\"_blank\">Postman</a> to test the <code>POST</code> methods in your API to create a new pet. Use the sample body below to send the <code>POST</code> request:\n        </p>\n        <pre>\n{\n    \"type\" : \"cat\",\n    \"price\" : 123.11\n}\n        </pre>\n    </body>\n</html>"})
            end
          end
          requestTemplates(
            {"application/json"=>"{\"statusCode\": 200}"})
          passthroughBehavior "when_no_match"
          type "mock"
        end
      end
      post do
        produces ["application/json"]
        responses do
          code 200 do
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
          uri "http://petstore-demo-endpoint.execute-api.com/petstore/pets"
          passthroughBehavior "when_no_match"
          httpMethod "POST"
          type "http"
        end
      end
      options do
        consumes ["application/json"]
        produces ["application/json"]
        responses do
          code 200 do
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
                {"method.response.header.Access-Control-Allow-Methods"=>"'POST,OPTIONS'",
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
  definitions do
    Empty do
      type "object"
    end
  end
end
```




## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcy-terui/rapis.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
