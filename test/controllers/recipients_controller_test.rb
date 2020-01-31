require 'test_helper'

class RecipientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipient = recipients(:one)
  end

  test "should get index" do
    get recipients_url, as: :json
    assert_response :success
  end

  test "should create recipient" do
    assert_difference('Recipient.count') do
      post recipients_url, params: { recipient: { address: @recipient.address, name: @recipient.name, phone: @recipient.phone, school_id: @recipient.school_id } }, as: :json
    end

    assert_response 201
  end

  test "should show recipient" do
    get recipient_url(@recipient), as: :json
    assert_response :success
  end

  test "should update recipient" do
    patch recipient_url(@recipient), params: { recipient: { address: @recipient.address, name: @recipient.name, phone: @recipient.phone, school_id: @recipient.school_id } }, as: :json
    assert_response 200
  end

  test "should destroy recipient" do
    assert_difference('Recipient.count', -1) do
      delete recipient_url(@recipient), as: :json
    end

    assert_response 204
  end
end
