Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.development?
      origins 'localhost:3000'
    elsif Rails.env.production?
      # origins '[here production's front-end URL]'
    end
    resource '*', 
      headers: :any, methods: [:get, :post, :patch, :put, :delete, :options],
      credentials: true
  end
end
