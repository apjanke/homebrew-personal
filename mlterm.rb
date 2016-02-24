class Mlterm < Formula
  desc "Multilingual Terminal Emulator (X11)"
  homepage "https://sourceforge.net/projects/mlterm/"
  url "https://downloads.sourceforge.net/project/mlterm/01release/mlterm-3.6.3/mlterm-3.6.3.tar.gz"
  sha256 "021935df82fd63a280500185e7c4b2ae833bd8c1f58e4386d0d772c55d4d2743"
  head "https://bitbucket.org/arakiken/mlterm", :using => :hg

  depends_on :x11
  depends_on "cairo" => "with-x11"
  depends_on "gdk-pixbuf"
  depends_on "libssh2"
  depends_on "fribidi"
  depends_on "pkg-config" => :build

  def install
    # utmp support causes errors during installation as non-root
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-utmp
      --with-imagelib=gdk-pixbuf
    ]

    # Fixes "Symbol not found: _kCFAllocatorDefault" runtime error
    ENV.append "LDFLAGS", "-framework CoreFoundation"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "mlterm version #{version}", shell_output("mlterm -version; true")
  end
end
