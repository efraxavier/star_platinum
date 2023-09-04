Quando('eu cadastro meu usuario') do
  user.load
  user.fill_user
  sleep(5)
end
  
Então('eu verifico se o usuario foi cadastrado') do
  @text = find('#description')
  expect(@texto.text).to eql 'Descrição'
end