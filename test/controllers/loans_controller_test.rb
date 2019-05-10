require 'test_helper'

class LoansControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @loan = loans(:active)
    @user = users(:admin)
    @item = items(:available)
    sign_in @user
  end

  test "should get index" do
    get loans_url
    assert_response :success
  end

  test "should get new" do
    get new_loan_url
    assert_response :success
  end

  test "should create loan" do
    item = items(:available)
    assert_difference('Loan.count') do
      post loans_url, params: { loan: { item_number: @item.number, member_id: @loan.member_id } }
    end

    assert_redirected_to member_url(@loan.member)
  end

  test "should show loan" do
    get loan_url(@loan)
    assert_response :success
  end

  test "should get edit" do
    get edit_loan_url(@loan)
    assert_response :success
  end

  test "should update loan" do
    patch loan_url(@loan), params: { loan: { due_at: @loan.due_at, ended: "1", item_id: @loan.item_id, member_id: @loan.member_id } }
    assert_redirected_to member_url(@loan.member)

    @loan.reload
    assert @loan.ended_at.present?
  end

  test "should update loan and mark as not ended" do
    loan = loans(:ended)
    patch loan_url(loan), params: { loan: { ended: "0" } }
    assert_redirected_to member_url(@loan.member)

    loan.reload
    assert loan.ended_at.nil?
  end

  test "should destroy loan" do
    assert_difference('Loan.count', -1) do
      delete loan_url(@loan)
    end

    assert_redirected_to loans_url
  end
end
