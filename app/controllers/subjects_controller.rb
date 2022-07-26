class SubjectsController < ApplicationController
  authorize_resource
  before_action :load_subject, only: :show

  def show
    @pagy, @questions = pagy(@subject.questions.recent_questions,
                             items: Settings.paging.per_page_10)
  end

  def index
    @q = Subject.ransack(params[:q])
    @pagy, @subjects = pagy(@q.result.includes(:questions).active
                                                .recent_subjects,
                            items: Settings.paging.per_page_15)
  end

  private

  def load_subject
    @subject = Subject.find_by id: params[:id]
    return if @subject

    flash[:danger] = t(".find_failed")
    redirect_to root_path
  end
end
