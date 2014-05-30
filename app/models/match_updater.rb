class MatchUpdater
  # include EventScorer # TODO?

  attr_reader :match

  # TODO spec
  def initialize(match, changes={})
    @match = match
  end

  # Changes the match, saving it and triggering all associated stuff (TODO)
  # TODO spec
  def save
    false # TODO
  end

  # Message to explain what was done after successful `save`
  # TODO spec
  def message
    # TODO
  end

end
