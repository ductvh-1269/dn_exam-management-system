class SubjectsController < ApplicationController
  before_action :load_subject, only: :show

  def show; end

  def index
    @pagy, @subjects = pagy(Subject.active.recent_subjects,
                            items: Settings.paging.subjects_per_page_15)
  end

  private

  def load_subject
    @subject = Subject.find_by id: params[:id]
    return if @subject

    flash[:danger] = t(".find_failed")
    redirect_to root_path
  end
end
