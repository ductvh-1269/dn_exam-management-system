class Admin::SubjectsController < AdminController
  before_action :load_subject, only: %i(new_import create_import export destroy)
  def new
    @subject = Subject.new
  end

  def create
    @subject = @current_user.subjects.build subject_params
    if @subject.save
      flash[:info] = t ".create_noti"
      redirect_to @subject
    else
      flash.now[:danger] = t ".create_failed"
      render :new
    end
  end

  def destroy
    if @subject.destroy
      flash.now[:success] = t ".delete_successed"
    else
      flash.now[:danger] = t ".delete_failed"
    end
  end

  def new_import; end

  def create_import
    file = params[:file]
    check_file file and return
    spreadsheet = Roo::Spreadsheet.open file
    questions = Array.new
    (2..spreadsheet.last_row).each do |i|
      row =  spreadsheet.row(i)
      question = @subject.questions.build
      if row[0]
        questions.pop unless is_one_correct_answer questions.last
        question.content = row[1]
        questions.push question
      else
        correct = row[3] ? "true_answer" : "false_answer"
        questions.last&.answers&.build(content: row[2], is_correct: correct)
      end
    end
    begin
      Question.transaction do
        questions.each(&:save!)
      end
    rescue StandardError => e
      flash[:danger] = e
    else
      flash[:success] = t ".import_done"
    ensure
      redirect_to :import_admin_subject_questions
    end
  end
  private

  def subject_params
    params.require(:subject).permit :name, :content
  end

  def check_file file
    return if file.original_filename.end_with? ".csv" || ".xlsx" || ".ods"

    flash[:danger] = t "file_is_invalid"
    redirect_to :import_admin_subject_questions and return true
  end

  def load_subject
    return if @subject = Subject.find_by(id: params[:subject_id])

    flash[:danger] = t ".subject_not_found"
    redirect_to :subjects and return
  end

  def is_one_correct_answer question
    question&.answers.select{|a| a.true_answer?}&.count == 1
  end
end
