# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    # 新規登録時に保存を許可するカラムを追加する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # 編集したデータをアップデートする時に保存を許可するカラムを追加する
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name postal_code address profile])
  end
end
