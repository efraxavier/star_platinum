#class UserClient
#  include HTTParty
#  base_uri ENV["base_uri"]
#
#  def post_create_session(payload)
#    HTTParty.post('/sessions', body: payload)
#  end
#
#end