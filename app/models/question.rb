class Question < ApplicationRecord
  ANSWER_TIME = 50.seconds

  belongs_to :game, touch: true
  has_many :audience_lies, -> { audience }, class_name: "Lie"
  has_many :our_lies, -> { our }, class_name: "Lie"
  has_many :answers

  enum :state,
       %w[initial open closed voting evaluated].index_by(&:itself),
       prefix: true

  validates :question, :points, presence: true

  def open!
    update!(state: :open, answerable_until: ANSWER_TIME.from_now)
    CloseQuestionJob.set(wait_until: answerable_until).perform_later(id)
  end

  def close!
    return unless state_open?

    update!(state: :closed)
    add_our_lies
  end

  def all_answered?
    answers.where(truth: false, our_lie: false).count >= Player.count
  end

  def open_voting!
    update!(state: :voting)
  end

  def evaluate!
    return if state_evaluated?

    transaction do
      award_points
      update!(state: :evaluated)
    end
  end

  private
    def add_our_lies
      players_with_answer_ids = answers.pluck(:player_id)

      Player.where.not(id: players_with_answer_ids).each.with_index do |player, index|
        answers.create!(text: our_lies[index].text, our_lie: true, player: player)
      end
    end

    def award_points
      answers.includes(:votes).each do |answer|
        next if answer.votes.empty?

        if answer.truth?
          answer.votes.each { |vote| vote.player.increment!(:points, vote.points) }
        elsif answer.player
          answer.player.increment!(:points, answer.votes.sum(&:points))
        end
      end
    end
end
