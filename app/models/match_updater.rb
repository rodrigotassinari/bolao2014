class MatchUpdater
  # include EventScorer # TODO?

  attr_reader :match
  attr_accessor :changes

  def initialize(match, changes={})
    @match = match
    @changes = changes
    @match_bettable_before_changes = match.bettable?
    @messages = []
  end

  def valid?
    raise ArgumentError, 'match is not persisted' unless match.persisted?
    raise ArgumentError, 'nothing to change on the match' if changes.empty?
    true
  end

  # Tries to change the match attributes and, if successful, queues the
  # match scoring (only if needed?), the new match available to bet notificattion
  # and returns true. If not, returns false with the errors set on the match object.
  def save
    match.attributes = changes
    if successful_match_change
      notify_users_if_match_is_now_bettable
      score_match_if_match_is_now_scorable
      true
    else
      false
    end
  end

  # Message to explain what was done after successful `save`
  def message
    return if @messages.empty?
    @messages.join(' ')
  end

  def errors
    match.errors
  end

  private

  def successful_match_change
    if valid? && match.changed? && match.save
      @messages << I18n.t('match_updater.match_changed')
      true
    else
      false
    end
  end

  def notify_users_if_match_is_now_bettable
    if !@match_bettable_before_changes && match.bettable?
      # send "match is now bettable" notification to all users
      User.find_each do |user|
        UsersMailer.async_deliver(:match_bettable_notification, match.id, user.id)
      end
      @messages << I18n.t('match_updater.users_notified')
    end
  end

  def score_match_if_match_is_now_scorable
    if match.scorable?
      # async score all match_bets for this match
      MatchScoreWorker.perform_async(match.id)
      @messages << I18n.t('match_updater.match_scored')
    end
  end

end
