class User < SitePrism::Page
    set_url ''
    element :new_transaction, 'a.button new'

    def fill_user
        new_transaction.click
    end
end