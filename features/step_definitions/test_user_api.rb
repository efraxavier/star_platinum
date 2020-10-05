Quando('eu faço login com meu usuario api com') do |table|
    @email = table.rows_hash['Email'].to_s
    @password = table.rows_hash['Password'].to_s
    @payload = payload_test(@email, @password)
    @post_session_req = @user_client.post_create_session(@payload)
end
  
Então('eu verifico se o usuario api foi logado') do
    verify_status_code_request(@post_session_req, expect = 200)
    parse_json_request(@post_session_req)  
end

Então('cadastro sua tarefa') do
    @header_cadastro = @jorge.@header
    @payload = payload_test(@email, @password)
    @post_session_req = @user_client.post_create_session(@payload)
end
  
Entao('verifico se a tarefa foi cadastrada') do
    pending # Write code here that turns the phrase above into concrete actions
end