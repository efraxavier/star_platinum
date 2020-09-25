Quando('eu cadastro meu usuario') do
  user.load
  user.fill_user
  sleep(5)
end
  
Então('eu verifico se o usuario foi cadastrado') do
  @texto = find('#notice')
  expect(@texto.text).to eql 'Usuário Criado com sucesso'
end