require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe '.find_by_credentials' do
    context 'with correct email and password' do
      it 'returns the user' do
        user = create(:user)

        returned_user = User.find_by_credentials(user.email, user.password)

        expect(returned_user).to eq(user)
      end
    end

    context 'with incorrect password' do
      it 'returns nil' do
        user = create(:user)

        returned_user = User.find_by_credentials(user.email, "wrongpassword")

        expect(returned_user).to be_nil
      end
    end
  end

  describe '#generate_auth_token' do
    it 'returns a JWT with the correct user id' do
      user = create(:user)

      returned_token = user.generate_auth_token
      decoded_token = AuthToken.decode(returned_token)

      expect(decoded_token[:user_id]).to eq(user.id)
    end
  end
end
