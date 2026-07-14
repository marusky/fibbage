class CloseQuestionJob < ApplicationJob
  queue_as :default

  def perform(question_id)
    question = Question.find_by(id: question_id)
    return unless question&.state_open?

    question.close!
  end
end
