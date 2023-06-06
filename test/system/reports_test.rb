# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    visit new_user_session_url
    fill_in 'Eメール', with: 'user1@test.com'
    fill_in 'パスワード', with: 'password123'
    click_button 'ログイン'

    assert_text 'ログインしました。'

    @report = reports(:report_by_user1)
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: @report.content
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text @report.title
    assert_text @report.content

    click_on '日報の一覧に戻る'
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first

    fill_in 'タイトル', with: '編集します'
    fill_in '内容', with: 'この日報を編集します'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text '編集します'
    assert_text 'この日報を編集します'

    click_on '日報の一覧に戻る'
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
    assert_selector 'h1', text: '日報の一覧'
  end
end
