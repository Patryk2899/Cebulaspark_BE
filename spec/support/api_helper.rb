module ApiHelper
  def authenticated_header(request, user)
    payload = Warden::JWTAuth::PayloadUserHelper.payload_for_user(user, 'user')
    token = Warden::JWTAuth::TokenEncoder.new.call(payload)
    headers = { 'Accept' => 'application/json',
                'Content-Type' => 'application/json',
                'Authorization' => "Bearer #{token}" }
    request.headers.merge!(headers)
  end
end
