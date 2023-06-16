# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @report_by_alice = reports(:report_by_alice)
    @report_by_bob = reports(:report_by_bob)
    @report_by_carol = reports(:report_by_carol)
  end

  test 'editable?' do
    assert @report_by_alice.editable?(@alice)
    assert_not @report_by_alice.editable?(@bob)
  end

  test 'created_on' do
    @report_by_alice.created_at = '2023-06-16 13:00'.in_time_zone
    assert_equal '2023-06-16'.to_date, @report_by_alice.created_on
  end

  test 'save_mentions' do
    # URLを含めないで日報を作成
    params = {
      user: users(:alice),
      title: 'I wrote the second report.',
      content: 'The weather is nice today.'
    }
    new_report = Report.create(params)
    assert_equal [], new_report.mentioning_reports

    # URLを含めて日報を作成
    params = {
      user: users(:dave),
      title: 'I mention to you.',
      content: "I mention to http://localhost:3000/reports/#{@report_by_alice.id} and http://localhost:3000/reports/#{@report_by_bob.id}."
    }
    report_with_mention = Report.create(params)
    assert_equal [@report_by_alice, @report_by_bob].sort, report_with_mention.mentioning_reports.sort

    # URLを変更して日報を更新
    params = {
      content: "I mention to http://localhost:3000/reports/#{@report_by_alice.id} and http://localhost:3000/reports/#{@report_by_carol.id}."
    }
    report_with_mention.update(params)
    assert_equal [@report_by_alice, @report_by_carol].sort, report_with_mention.reload.mentioning_reports.sort

    # URLを削除して日報を更新
    report_with_mention.update(content: 'I do not mention.')
    assert_equal [], report_with_mention.reload.mentioning_reports
  end
end
