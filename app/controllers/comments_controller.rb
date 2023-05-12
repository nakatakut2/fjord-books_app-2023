# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy]
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      @comments = @commentable.comments
      render_commentable_show
    end
  end

  def destroy
    @comment.destroy
    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_commentable
    if params[:book_id]
      @commentable = Book.find(params[:book_id])
    elsif params[:report_id]
      @commentable = Report.find(params[:report_id])
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def render_commentable_show
    case @commentable.class
    when Book
      @book = @commentable
      render 'books/show'
    when Report
      @report = @commentable
      render 'reports/show'
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
