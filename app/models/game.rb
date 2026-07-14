class Game < ApplicationRecord
  has_many :questions

  broadcasts_refreshes

  validates :code, :question_number, presence: true

  def current_question
    questions.find_by(order: question_number)
  end

  def last_question?
    !questions.where(order: question_number + 1).exists?
  end

  def next_question!
    next_question_number = question_number + 1

    return unless Question.where(order: next_question_number).exists?

    update!(question_number: question_number + 1)
  end
end
