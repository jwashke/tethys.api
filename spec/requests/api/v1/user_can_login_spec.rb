require 'rails_helper'

RSpec.describe 'POST /api/v1/auth' do
  context 'with valid credentials' do
    it 'returns 200 OK and a authorization token' do
      user = create(:user)
      params = {
        format: :json,
        user: {
          email: user.email,
          password: user.password
        }
      }
      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }

      post '/api/v1/auth', params: params.to_json, headers: headers
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      decoded_token = AuthToken.decode(parsed_response[:auth_token])

      expect(response.status).to eq(200)
      expect(decoded_token[:user_id]).to eq(user.id)
    end
  end

  context 'with invalid credentials' do
    it 'returns 401 Unauthorized and an error message' do
      user = create(:user)
      params = {
        format: :json,
        user: {
          email: user.email,
          password: 'incorrectpassword'
        }
      }
      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }

      post '/api/v1/auth', params: params.to_json, headers: headers
      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)
      expect(parsed_response[:error]).to eq('Invalid email or password')
    end
  end
end
