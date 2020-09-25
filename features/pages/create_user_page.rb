class User < SitePrism::Page
    set_url 'users/new'
    element :nome, '#user_name'
    element :sobrenome, '#user_lastname'
    element :email, '#user_email'
    element :endereco, '#user_address'
    element :universidade, '#user_university'
    element :profissao, '#user_profile'
    element :genero, '#user_gender'
    element :idade, '#user_age'

    element :criar, 'input[value="Criar"]'

    def fill_user
        nome.set 'Jorge'
        sobrenome.set 'George'
        email.set 'jorge@jorge.com'
        endereco.set 'Rua Jorge'
        universidade.set 'UFJ'
        profissao.set 'Desempregado'
        genero.set 'Masculino'
        idade.set '68'
        criar.click
    end
end