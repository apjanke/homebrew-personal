class LarnRlM < Formula
  desc "RL_M fork of Larn, a roguelike"
  homepage "https://github.com/atsb/RL_M"
  url "https://github.com/atsb/RL_M/archive/v13.5.tar.gz"
  version "13.5"
  sha256 "513f0b9cc11b1d8f33b78933df0ce332036c025cd4281452338f51d4b54ead5a"

  depends_on "homebrew/dupes/ncurses"
  depends_on "cmake"

  def install
    cd "build"
    system "cmake", ".", *std_cmake_args
    system "make"
    cp larn, bin
  end

  test do
    assert_match /Cmd line format: larn/, shell_output("#{bin}/larn -h")
  end
end
