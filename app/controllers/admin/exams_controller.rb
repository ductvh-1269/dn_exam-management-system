class Admin::ExamsController < AdminController
  before_action :load_exam, only: :show
  before_action :load_exams, only: %i(index search)
  def index; end

  def show
    render template: "exams/show"
  end

  def search; end

  private
  def load_exam
    return if @exam = Exam.find_by(id: params[:id])

    flash[:danger] = t ".exam_not_found"
    redirect_to :admin_exams
  end

  def load_exams
    @pagy, @exams = pagy Exam.by_key_word_with_relation_tables(params[:query]),
                         items: load_per_page(Settings.paging.per_page_5)
  end
end
