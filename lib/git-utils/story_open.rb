require 'git-utils/command'

class StoryOpen < Command

  # Returns a command appropriate for executing at the command line
  # I.e., 'open https://www.pivotaltracker.com/story/show/62831853'
  def cmd
    story_ids.map do |id|
      "open https://www.pivotaltracker.com/story/show/#{id}"
    end.join(' ; ')
  end

  def run!
    system cmd
  end
end