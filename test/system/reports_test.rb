# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    visit new_user_session_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'

    assert_text 'ログインしました。'

    @report = reports(:report_by_alice)
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: "I'm alice."
    fill_in '内容', with: 'Nice to meet you.'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text "I'm alice."
    assert_text 'Nice to meet you.'

    click_on '日報の一覧に戻る'
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first

    fill_in 'タイトル', with: '祖母のお祝いで親族集結'
    fill_in '内容', with: '祖母の元気な顔が見れてよかったけど、普段会わない親族もいて変に気を遣ってしまった(笑)'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text '祖母のお祝いで親族集結'
    assert_text '祖母の元気な顔が見れてよかったけど、普段会わない親族もいて変に気を遣ってしまった(笑)'

    click_on '日報の一覧に戻る'
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
    assert_no_text '祖母のお祝いで親族集結'
    assert_no_text '祖母の元気な顔が見れてよかったけど、普段会わない親族もいて変に気を遣ってしまった(笑)'

    assert_selector 'h1', text: '日報の一覧'
  end
end
