# By default, command runs only when story is finished
class FinishedCommand < Command

  def run!
    check_finishes unless override?
    system cmd
  end

  private

    # Checks to see if the most recent commit finishes the story
    # We look for 'Finishes' or 'Delivers' and issue a warning if neither is
    # in the most recent commit. (Also supports 'Finished' and 'Delivered'.)
    def check_finishes
      unless finished?
        warning =  "Warning: Unfinished story\n"
        warning += "Run `git commit --amend` to add 'Finishes' or 'Delivers' "
        warning += "to the commit message\n"
        warning += "Use --force to override"
        $stderr.puts warning
        exit 1
      end
    end

    def finished?
      !!(`git log -1`.match(/Finishe(s|d)|Deliver(s|ed)|Fixe(s|d) #\d+/i))
    end

    def override?
      options.override
    end
end