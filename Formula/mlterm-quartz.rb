class MltermQuartz < Formula
  desc "Multilingual Terminal Emulator (Quartz)"
  homepage "https://sourceforge.net/projects/mlterm/"
  url "https://downloads.sourceforge.net/project/mlterm/01release/mlterm-3.6.3/mlterm-3.6.3.tar.gz"
  sha256 "021935df82fd63a280500185e7c4b2ae833bd8c1f58e4386d0d772c55d4d2743"
  head "https://bitbucket.org/arakiken/mlterm", :using => :hg

  keg_only "This prevents conflicts with the X11 mlterm"

  option "with-gtk3", "Use GTK+ 3 instead of GTK+ 2"

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "libssh2"
  depends_on "fribidi"
  if build.with? "gtk3"
    depends_on "gtk+3"
  else
    depends_on "gtk+"
  end
  depends_on "pkg-config" => :build

  def install
    # utmp support causes errors during installation as non-root
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-utmp
      --with-gui=quartz
    ]
    args << (build.with?("gtk3") ? "--with-gtk=3.0" : "--with-gtk=2.0")

    # Fixes "Symbol not found: _kCFAllocatorDefault" runtime error
    ENV.append "LDFLAGS", "-framework CoreFoundation"

    system "./configure", *args
    system "make", "install"

    # Hackish use of their app building script
    system "cp", "-r", "cocoa/mlterm.app", ENV["HOME"] # Yes, it must be $HOME
    system "./cocoa/install.sh", prefix
    system "mv", "#{ENV["HOME"]}/mlterm.app", "."
    prefix.install "mlterm.app"
  end

  # No test because the Quartz version doesn't run outside the app bundle
end
