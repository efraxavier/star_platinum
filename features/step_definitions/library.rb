# Prepare Request

def prepare_request(token, payload, more_headers = nil)
  token == nil ? header_send = {'Content-Type' => 'application/json'} : header_send = {'Content-Type' => 'application/json', 'Authorization' => token}
  if more_headers == nil
    {body: payload == nil ? nil : payload.to_json, headers: {'Content-Type' => 'application/json', 'Authorization' => token}}
    request = {body: payload == nil ? nil : payload.to_json, headers: header_send}
  else
    more_headers.each do |key, value|
      header_send[key] = value
    end
    {body: payload == nil ? nil : payload.to_json, headers: header_send}
    request = {body: payload == nil ? nil : payload.to_json, headers: header_send}
  end
  return request
end

# HTTP Verbs

def post_payload(http_party, token, url, payload, headers)
    http_party.class.post(url, prepare_request(token, payload, headers))
end

def patch_payload(http_party, token, url, payload, headers = nil)
    http_party.class.patch(url, prepare_request(token, payload, headers))
end

def get_data(http_party, token, url, more_headers = nil)
    http_party.class.get(URI.parse(URI.encode(url)), prepare_request(token, nil, more_headers))
end

def delete_data(http_party, token, url, more_headers = nil)
    http_party.class.delete(URI.parse(URI.encode(url)), prepare_request(token, nil, more_headers))
end

def put_payload(http_party, token, url, payload, headers = nil)
    http_party.class.put(url, prepare_request(token, payload, headers))
end

def put_headerless(http_party, token, url, payload)
  http_party.class.put(url, prepare_request(token, payload))
end

def delete_payload(http_party, token, url, payload, type = nil)
  http_party.class.delete(url, prepare_request(token, payload, type))
end

# Status Code Expectiation Check

def verify_status_code_request(request, expect)
    if request.request.options[:body] == "" or request.request.options[:body] == nil
      @message = "A requisição não possui payload"
    else
      begin
        JSON.parse(request.request.options[:body])
      rescue => e
        @message = "O payload informado na requisição não é um JSON"
        request.request.options[:body] = nil
      end
    end
  
    begin
      log_util("URL Request: #{request.request.last_uri}")
      log_util("Method Request: #{request.request.http_method}")
      request.request.options[:body] == nil ? log_util(@message) : log_util("Payload Enviado: #{JSON.pretty_generate(JSON.parse(request.request.options[:body]))}")
      log_util("HTTP Code Esperado: #{expect} - HTTP Code Recebido: #{request.code}")
      expect(request.code).to eq(expect)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      begin
        response_error = JSON.pretty_generate(JSON.parse(request.body)) if request.request.options[:body] != nil or request.parsed_response != nil
      rescue JSON::ParserError
        response_error = request.body
      end
      log_util("Response de Erro: #{response_error}")
      raise e
    end
end
  
def parse_json_request(message = nil, request)
    message == nil ? message = "Response" : message
    return request.body if request.body == nil
    begin
      response = JSON.parse(request.body)
      log_util("#{message}: #{JSON.pretty_generate(response)}")
    rescue JSON::ParserError => errorJson
      response = request.body
      log_util("Response: #{response}")
    end
    return response
end

# Contract Verification

def verify_contract(request, contract_expect, curb = nil)
    begin
      curb == true ? @request_parse = request : @request_parse = JSON.parse(request.body)
    rescue NoMethodError => e
      @request_parse = request
    rescue JSON::ParserError => errorparse
      log_util("RED-FIVE: Erro ao parsear o response: #{errorparse}")
      return
    end
  
    begin
      @contract_validate_values = expect(@request_parse).to match_json_schema(contract_expect)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      raise e
    end
  
    begin
      @response_expect_open = File.read("#{JSON_VALIDATE}/#{contract_expect}.json")
      @response_expect = JSON.parse(@response_expect_open)
  
      begin
        get_keys = @request_parse.keys
        expect_keys = @response_expect['properties'].keys
      rescue => exception
        get_keys = @request_parse[0].keys
        expect_keys = @response_expect['items']['properties'].keys
      end
  
      for i in 0...expect_keys.length do
        field = expect_keys[i]
        begin
          field_type = @response_expect['properties'][field]['type']
        rescue => exception
          field_type = @response_expect['items']['properties'][field]['type']
        end
        if field_type.eql?('object')
          begin
            expect(@request_parse[field].keys).to eq(@response_expect['properties'][field]['properties'].keys)
          rescue => error_field
            log_util("RED-FIVE: Nome do contrato: #{contract_expect}.json - Erro ao tentar validar o campo #{field}")
            raise error_field
          end
        end
      end
      expect(get_keys).to eq(expect_keys)
      log_util("Contrato OK - Nome do contrato: #{contract_expect}.json")
    rescue RSpec::Expectations::ExpectationNotMetError => e
      log_util("Houveram alterações no contrato: #{contract_expect}.json")
      number_fields = @request_parse.length
  
      if field_type.eql?('object')
        log_util("Divergência nos campos do objeto #{field}")
        log_util("Campos esperados: #{@request_parse[field].keys} ")
        log_util("Campos obtidos: #{@response_expect['properties'][field]['properties'].keys}")
      end
  
      contador = 0
      while contador <= number_fields
        if (@response_expect['properties'].keys[contador] != @request_parse.keys[contador])
          log_util("Era esperado o campo: #{@response_expect['properties'].keys[contador]} e foi recebido o campo: #{@request_parse.keys[contador]}")
          break
        end
        contador += 1
      end
      raise e
    end
  end

  def generate_date_today(number_seconds_future)
    date = DateTime.now + Rational(number_seconds_future, 86400)
    Time.now.zone == "-03" ? date = date.to_s.gsub("-03:00", ".000") : date = date - Rational(10800, 86400); date = date.to_s.gsub("+00:00", ".000")
    return date
  end