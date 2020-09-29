class UserClient
  include HTTParty
  base_uri ENV["base_uri"]

  def post_create_session(token, payload, headers)
    post_payload(self, token, "/sessions", payload, headers)
  end

end