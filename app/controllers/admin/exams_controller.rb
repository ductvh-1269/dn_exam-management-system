class Admin::ExamsController < AdminController
  def index
    result = Exam.by_key_word_with_relation_tables params[:query]
    @pagy, @exams = pagy result,
                         items: load_per_page(Settings.paging.per_page_5)
  end
end
