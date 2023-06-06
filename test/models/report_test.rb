# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @user1 = users(:user1)
    @user2 = users(:user2)
    @report_by_user1 = reports(:report_by_user1)
    @report_by_user2 = reports(:report_by_user2)
    @report_by_user3 = reports(:report_by_user3)
    @report_to_mention_by_user4 = reports(:report_to_mention_by_user4)
  end

  test 'editable?' do
    assert @report_by_user1.editable?(@user1)
    assert_not @report_by_user1.editable?(@user2)
  end

  test 'created_on' do
    assert_not_equal Date.parse('Fri, 30 Jnue 2023'), @report_by_user1.created_on
    assert_equal Date.parse('Tue, 30 May 2023'), @report_by_user1.created_on
  end

  test 'save_mentions' do
    # URLを含めないで日報を作成
    assert_equal [], @report_by_user1.send(:save_mentions)

    # URLを含めて日報を作成
    assert_equal [@report_by_user1, @report_by_user2].sort, @report_to_mention_by_user4.send(:save_mentions).sort

    # URLを変更して日報を更新
    @report_to_mention_by_user4.update(content: 'I mention to http://localhost:3000/reports/1 and http://localhost:3000/reports/3.')
    assert_equal [@report_by_user1, @report_by_user3].sort, Report.find(@report_to_mention_by_user4.id).send(:save_mentions).sort

    # URLを削除して日報を更新
    @report_to_mention_by_user4.update(content: 'I do not tmention.')
    assert_equal [], Report.find(@report_to_mention_by_user4.id).send(:save_mentions)
  end
end
