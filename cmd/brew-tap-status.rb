#:  * `tap-status` [`--quiet`] [<taps>]:
#:    Display a brief summary of the status of installed or selected taps.
#:
#:    Pass `--quiet` to display only taps with non-default status.
#:
#:    If <taps> is not supplied, then info on all installed taps is displayed.

require "tap"

module GitRepositoryExtension
  def git_local_changes?
    return unless git? && Utils.git_available?
    cd do
      changes = Utils.popen_read(
        "git", "status", "--porcelain"
      ).chomp
      result = !changes.empty?
      return result
    end
  end
end

module Homebrew
  module_function

  def tap_status
  	if ARGV.named.empty?
  		taps = Tap
  	else
  		taps = ARGV.named.sort
  	end

  	print_tap_status(taps.sort_by(&:to_s))
  end

  def print_tap_status(taps)
    taps.each_with_index do |tap|
      statuses = detect_tap_status(tap)
      next if ARGV.include? "--quiet" and statuses.empty?
      puts "#{tap}: #{statuses.join(", ")}"
    end
  end

  def detect_tap_status(tap)
    things = [];
    if !tap.git?
      things << "not git"
      return things
    end
    branch = tap.git_branch
    if branch != "master"
      things << "branch #{branch}"
    end
    things << "pinned" if tap.pinned?
    things << "custom-remote" if tap.custom_remote?
    things << "local changes" if tap.path.git_local_changes?
    things
  end
end


# Adapter for using as an external command

Homebrew.tap_status