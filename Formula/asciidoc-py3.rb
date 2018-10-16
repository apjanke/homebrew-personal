class AsciidocPy3 < Formula
  desc "Formatter/translator for text files to numerous formats (Python 3 version)"
  homepage "https://github.com/asciidoc/asciidoc-py3"
  head "https://github.com/asciidoc/asciidoc-py3.git"

  conflicts_with "asciidoc", :because => "both install the same program"

  depends_on "autoconf" => :build
  depends_on "docbook-xsl" => :build
  depends_on "docbook"
  depends_on "python"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "docs"
  end

  def caveats
    <<~EOS
      If you intend to process AsciiDoc files through an XML stage
      (such as a2x for manpage generation) you need to add something
      like:

        export XML_CATALOG_FILES=#{etc}/xml/catalog

      to your shell rc file so that xmllint can find AsciiDoc's
      catalog files.

      See `man 1 xmllint' for more.
    EOS
  end

  test do
    (testpath/"test.txt").write("== Hello World!")
    system "#{bin}/asciidoc", "-b", "html5", "-o", "test.html", "test.txt"
    assert_match %r{\<h2 id="_hello_world"\>Hello World!\</h2\>}, File.read("test.html")
  end
end
