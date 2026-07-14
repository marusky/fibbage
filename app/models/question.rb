class Question < ApplicationRecord
  ANSWER_TIME = 50.seconds
  AUDIENCE_POINTS_POOL = 500

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
    add_audience_lie
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
      our_lie_pool = our_lies.to_a
      return if our_lie_pool.empty?

      Player.where.not(id: players_with_answer_ids).each.with_index do |player, index|
        answers.create!(text: our_lie_pool[index % our_lie_pool.size].text, our_lie: true, player: player)
      end
    end

    def add_audience_lie
      counts = AudienceChoice.where(lie_id: audience_lies.select(:id)).group(:lie_id).count
      return if counts.empty?

      winning_lie_id = counts.max_by { |_lie_id, count| count }.first
      answers.create!(text: audience_lies.find(winning_lie_id).text, audience_lie: true)
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

      award_audience_points
    end

    def award_audience_points
      loaded_answers = answers.includes(:audience_votes).to_a
      total = loaded_answers.sum { |answer| answer.audience_votes.size }
      return if total.zero?

      loaded_answers.each do |answer|
        next if answer.audience_votes.empty? || answer.player.nil?

        answer.player.increment!(:points, (AUDIENCE_POINTS_POOL * answer.audience_votes.size / total.to_f).round)
      end
    end
end
