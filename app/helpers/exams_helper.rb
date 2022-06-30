module ExamsHelper
  def generate_question_content index, content
    t "exams.show.question #{index + 1}: #{content}"
  end
end
