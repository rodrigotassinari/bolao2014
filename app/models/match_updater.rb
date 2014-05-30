class MatchUpdater
  # include EventScorer # TODO?

  attr_reader :match
  attr_accessor :changes

  def initialize(match, changes={})
    @match = match
    @changes = changes
  end

  # TODO spec
  def valid?
    raise ArgumentError, 'match is not persisted' unless match.persisted?
    raise ArgumentError, 'nothing to change on the match' if changes.empty?
  end

  # Tries to change the match attributes and, if successful, queues the
  # match scoring (only if needed?) and returns true. If not, returns
  # false with the errors set on the match object.
  # TODO spec
  def save
    match.attributes = changes
    if match.save
      match.score!
      true
    else
      false
    end
  end

  # Message to explain what was done after successful `save`
  # TODO spec
  def message
    # TODO
  end

end
