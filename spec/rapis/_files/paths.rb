item "/" do
  get do
    consumes ["application/json"]
    produces ["text/html"]
    responses do
      code "200" do
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
            {"text/html"=>"<html></html>"})
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
item "/pets" do
  get do
    produces ["application/json"]
    parameters do
      query "type" do
        required false
        type "string"
      end
      query "page" do
        required false
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
      uri "http://petstore-demo-endpoint.execute-api.com/petstore/pets"
      passthroughBehavior "when_no_match"
      httpMethod "GET"
      requestParameters(
        {"integration.request.querystring.page"=>"method.request.querystring.page",
         "integration.request.querystring.type"=>"method.request.querystring.type"})
      type "http"
    end
  end
  post do
    produces ["application/json"]
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
            {"method.response.header.Access-Control-Allow-Methods"=>"'POST,GET,OPTIONS'",
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
