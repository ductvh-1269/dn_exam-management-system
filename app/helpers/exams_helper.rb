module ExamsHelper
  def generate_question_content index, content
    t "exams.show.question #{index + 1}: #{content}"
  end

  def load_exam_path user
    return :admin_exams if user&.admin?
    :exams
  end

  def load_user_name exam
    "#{exam.user.first_name} #{exam.user.last_name}"
  end
end
