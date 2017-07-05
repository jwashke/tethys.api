class AuthToken
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV['token_key_base'])
  end

  def self.decode(token)
    payload = JWT.decode(token, ENV['token_key_base'])[0]
    DecodedAuthToken.new(payload)
  rescue
    nil
  end
end

class DecodedAuthToken < HashWithIndifferentAccess
  def expired?
    self[:exp] <= Time.now.to_i
  end
end
