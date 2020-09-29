def payload_test(field_email, field_password)
  {
    "session": {
        "email": field_email,
        "password": field_password
    }
  }
end

def headers_test(token) 
  {
    'Content-Type': 'application/json',
    Accept: 'application/vnd.tasksmanager.v2',
    Authorization: token
  }
end