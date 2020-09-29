Quando('eu cadastro meu usuario api com') do |table|
    @email = table.rows_hash['Email'].to_s
    @password = table.rows_hash['Password'].to_s
    @payload = payload_test(@email, @password)
    @post_session_req = @user_client.post_create_session(nil, @payload, nil)
end
  
Então('eu verifico se o usuario api foi cadastrado') do
    verify_status_code_request(@post_session_req, expect = 200)
    parse_json_request(@post_session_req)  
end