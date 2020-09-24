#language: pt

Funcionalidade: Eu como usuario quero criar uma conta

-Eu como usuario
-Quero me cadastrar

@create_user
Cenario: Cadastrar com sucesso
Quando eu cadastro meu usuario
Então eu verifico se o usuario foi cadastrado