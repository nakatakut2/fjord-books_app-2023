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

  def save_with_mentions
    success = false
    ActiveRecord::Base.transaction do
      success = save
      success &= save_mentions
      raise ActiveRecord::Rollback unless success
    end
    success
  end

  def update_with_mentions(params)
    success = false
    ActiveRecord::Base.transaction do
      success = update(params)
      success &= save_mentions
      raise ActiveRecord::Rollback unless success
    end
    success
  end

  def save_mentions
    mention_success = true

    before_ids = mentioning_reports.ids
    after_ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).uniq.flatten.map(&:to_i)

    to_destroy_mentioned_ids = before_ids - after_ids
    Mention.where(mentioning_report_id: id, mentioned_report_id: to_destroy_mentioned_ids).find_each do |m|
      mention_success &= m.destroy
    end

    to_create_mentioned_ids = after_ids - before_ids
    mention_success &= to_create_mentioned_ids.all? { |mentioned_id| Mention.create(mentioning_report_id: id, mentioned_report_id: mentioned_id) }
    mention_success
  end
end
