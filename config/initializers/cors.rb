Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.development?
      origins 'localhost:3000'
    elsif Rails.env.production?
      origins 'https://devreturns-front.vercel.app'
    end
    resource '*', 
      headers: :any, methods: [:get, :post, :patch, :put, :delete, :options],
      credentials: true
  end
end