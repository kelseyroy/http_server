require "./features/steps/shared.rb"

class Spinach::Features::MethodNotAllowed < Spinach::FeatureSteps
  include Shared::Standard

  step 'I make a POST request to "/simple_get"' do
    @response = Requests.post("/simple_get")
  end

  step 'my response should have allowed headers of GET, HEAD, OPTIONS' do
    expect(@response.allowed_headers).to contain_exactly("GET", "HEAD", "OPTIONS")
  end

  step 'I make a DELETE request to "/simple_get_with_body"' do
    @response = Requests.delete("/simple_get_with_body")
  end

  step 'my response should have allowed headers of GET, HEAD, OPTIONS' do
    expect(@response.allowed_headers).to contain_exactly("GET", "HEAD", "OPTIONS")
  end
end
