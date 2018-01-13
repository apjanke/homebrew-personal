class GoogleDepotTools < Formula
  desc "Google depot_tools, for building Dart"
  homepage "https://dev.chromium.org/developers/how-tos/depottools"
  head "https://chromium.googlesource.com/chromium/tools/depot_tools.git"

  def install
    libexec.install Dir["*"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test depot`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
