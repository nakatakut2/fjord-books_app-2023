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
    assert_not_equal Date.parse('Fri, 30 Jnue 2023'), @report_by_alice.created_on
    assert_equal Date.current, @report_by_alice.created_on
  end

  test 'save_mentions' do
    # URLを含めないで日報を作成
    assert_equal [], @report_by_alice.trigger_save_mentions

    # URLを含めて日報を作成
    report_with_mention = Report.create(
      user: users(:dave),
      title: 'I mention to you.',
      content: "I mention to http://localhost:3000/reports/#{@report_by_alice.id} and http://localhost:3000/reports/#{@report_by_bob.id}."
    )
    assert_equal [@report_by_alice, @report_by_bob].sort, report_with_mention.mentioning_reports.sort

    # URLを変更して日報を更新
    report_with_updated_mention = Report.update(report_with_mention.id, content: "I mention to http://localhost:3000/reports/#{@report_by_alice.id} and http://localhost:3000/reports/#{@report_by_carol.id}.")
    assert_equal [@report_by_alice, @report_by_carol].sort, report_with_updated_mention.mentioning_reports.sort

    # URLを削除して日報を更新
    report_with_mention.update(content: 'I do not mention.')
    assert_equal [], Report.find(report_with_mention.id).trigger_save_mentions
  end
end
