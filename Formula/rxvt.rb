class Rxvt < Formula
  desc "Classic VT102 terminal emulator for X11"
  homepage "http://rxvt.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/rxvt/rxvt/2.6.4/rxvt-2.6.4.tar.gz"
  sha256 "af0b90bb4d563aafeabcb4c237bd66668740743531e025a70d61a32d214f2242"

  devel do
    url "https://downloads.sourceforge.net/project/rxvt/rxvt-dev/2.7.10/rxvt-2.7.10.tar.gz"
    sha256 "616ad56502820264e6933d07bc4eb752aa6940ec14add6e780ffccf15f38d449"
  end

  depends_on :x11

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-xpm-background
      --enable-transparency
      --enable-menubar
      --enable-kanji
      --enable-graphics
      --enable-xim
      --enable-xgetdefault
      --with-terminfo=#{pkgshare}/terminfo
      --with-term=rxvt
    ]
    if build.devel?
      more_args = %W[
        --enable-languages
        --enable-rxvt-scroll
        --enable-xterm-scroll
        --enable-next-scroll
        --enable-frills
        --enable-linespace
        --enable-24bit
        --enable-smart-resize
        --enable-256-color
        --with-xpm
      ]
      args.push(*more_args)
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/rxvt -help 2>&1 | cat")
  end
end
