# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :active_mentions, class_name: 'Mention', foreign_key: 'mentioning_report_id', inverse_of: :mentioning_report, dependent: :destroy
  has_many :mentioning_reports, through: :active_mentions, source: :mentioned_report
  has_many :passive_mentions, class_name: 'Mention', foreign_key: 'mentioned_report_id', inverse_of: :mentioned_report, dependent: :destroy
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioning_report
  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def report_mention_save
    ActiveRecord::Base.transaction(joinable: false, requires_new: true) do
      save!
      mention_save
    end
  end

  def report_mention_update(params)
    ActiveRecord::Base.transaction(joinable: false, requires_new: true) do
      update!(params)
      mention_save
    end
  end

  def mention_save
    before = []
    mentioning_reports.ids.each do |before_mentioned_id|
      before << [id, before_mentioned_id]
    end
    after = []
    content.scan(%r{http://localhost:3000/reports/(\d+)}).uniq.flatten.map(&:to_i).each do |after_mentioned_id|
      after << [id, after_mentioned_id]
    end

    (before - after).each do |r|
      Mention.where(mentioning_report_id: r[0], mentioned_report_id: r[1]).find_each(&:destroy!)
    end

    (after - before).each do |r|
      Mention.create!(mentioning_report_id: r[0], mentioned_report_id: r[1])
    end
  end
end
