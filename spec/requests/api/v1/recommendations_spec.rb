require 'rails_helper'

describe "test recommendation" do

  before(:all) do
    @sample_user = User.find(35688)
    @url_prefix = "/api/v1/recommendations"
    # prepare_test_database
  end

  def prepare_test_url(user_id, strategy)
    [@url_prefix, user_id, strategy].join("/")
  end

  def prepare_test_database
    Rails.application.load_tasks
    Rake::Task['prepare_data:user'].invoke
    Rake::Task['prepare_data:category'].invoke
    Rake::Task['prepare_data:item_and_associations'].invoke
    Rake::Task['prepare_data:associations_user_and_items'].invoke    
  end

  it 'find by category' do
    get prepare_test_url(@sample_user.id.to_s, "category")
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(json.length).to be > 0
  end

  it 'find by similar users' do
    get prepare_test_url(@sample_user.id.to_s, "user")
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(json.length).to be > 0
  end  
end