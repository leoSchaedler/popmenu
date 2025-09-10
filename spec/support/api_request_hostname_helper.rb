module ApiRequestHelpers
  def set_api_host
    # Set the host for all api Rspec requests
    host! "www.example.com"
  end
end
