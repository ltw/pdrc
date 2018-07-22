require 'spec_helper'

describe PDRC::PagerdutyError do
  let(:message) { 'Foo' }
  let(:params) do
    {
      title: 'error_title',
      detail: 'error_detail',
      body: 'error_body',
      raw_body: 'error_raw_body',
      status_code: 'error_status_code'
    }
  end

  before do
    @pdrc = PDRC::PagerdutyError.new(message, params)
  end

  it "adds the error params to the error message" do
    expected_message = "Foo "                               \
                       "@title=\"error_title\", "           \
                       "@detail=\"error_detail\", "         \
                       "@body=\"error_body\", "             \
                       "@raw_body=\"error_raw_body\", "     \
                       "@status_code=\"error_status_code\""

    expect(@pdrc.message).to eq(expected_message)
  end

  it 'sets the title attribute' do
    expect(@pdrc.title).to eq(params[:title])
  end

  it 'sets the detail attribute' do
    expect(@pdrc.detail).to eq(params[:detail])
  end

  it 'sets the body attribute' do
    expect(@pdrc.body).to eq(params[:body])
  end

  it 'sets the raw_body attribute' do
    expect(@pdrc.raw_body).to eq(params[:raw_body])
  end

  it 'sets the status_code attribute' do
    expect(@pdrc.status_code).to eq(params[:status_code])
  end
end
