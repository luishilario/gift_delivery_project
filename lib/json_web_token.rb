class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1ODA1NDAzNTF9.HJslKmG1-8P9jHZIYMHM-nIpUs9pNrETRz5rEG-1B2g')
    end
    
    def decode(token)
      body = JWT.decode(token, 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1ODA1NDAzNTF9.HJslKmG1-8P9jHZIYMHM-nIpUs9pNrETRz5rEG-1B2g')[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end