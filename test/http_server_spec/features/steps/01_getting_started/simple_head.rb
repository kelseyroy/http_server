require "./features/steps/shared.rb"

class Spinach::Features::SimpleHead < Spinach::FeatureSteps
  include Shared::Standard

  step 'I make a HEAD request to "/simple_get"' do
    @response = Requests.head("/simple_get")
  end

  step 'I make a HEAD request to "/head_request"' do
    @response = Requests.head("/head_request")
  end
  
  step 'I make a GET request to "/head_request"' do
    @response = Requests.get("/head_request")
  end

  step 'my response should have a body with the text "This body does not show up in a HEAD request"' do
    expect(@response.body).to eq "This body does not show up in a HEAD request"
  end
end
