class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, 'qwertyuiop')
    end
    
    def decode(token)
      body = JWT.decode(token, 'qwertyuiop')[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end