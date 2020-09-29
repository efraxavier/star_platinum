#language: pt

Funcionalidade: Teste api

-Eu como usuario api
-Quero me cadastrar api

@create_user_api
Esquema do Cenario: Cadastrar com sucesso api
Quando eu cadastro meu usuario api com 
|Email   |  brunobatista66@gmail.com  |
|Password|  123456                    |
Então eu verifico se o usuario api foi cadastrado