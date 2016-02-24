class Icmake < Formula
  desc "Icmake: a make alternative"
  homepage "https://fbb-git.github.io/icmake/"
  url "https://downloads.sourceforge.net/project/icmake/icmake/7.22.01/icmake_7.22.01.orig.tar.gz"
  sha256 "b522e7937e9d4f0bec738dfce371673e3c4a8bc9f4d209a51631e5ed59ba66c7"

  patch :DATA

  def install
    # Completely overwrite their config file, since it is not programatically
    # configurable
    (buildpath/"INSTALL.im").atomic_write <<-EOS.undent
      #define BINDIR      "#{bin}"
      #define SKELDIR     "#{share}/icmake"
      #define MANDIR      "#{man}"
      #define LIBDIR      "#{libexec}"
      #define CONFDIR     "#{etc}/icmake"
      #define DOCDIR      "#{doc}"
      #define DOCDOCDIR   "#{doc}"
    EOS

    system "./icm_bootstrap", "/"
    system "./icm_install", "strip", "all", "/"
  end

end

__END__
diff --git a/scripts/conversions b/scripts/conversions
index f575de3..5de2711 100644
--- a/scripts/conversions
+++ b/scripts/conversions
@@ -5,23 +5,8 @@ CONFIG=INSTALL.im
 
 ROOT=`echo ${ROOT}/ | sed 's,//,/,g' | sed 's,//,/,g'`
 
-EXTENSION=`grep '^#' $CONFIG | grep "#define[[:space:]]\+EXTENSION" | \
-            sed 's,.*EXTENSION[[:space:]]\+\"\([^"]*\)".*,'${ROOT}'\1,'`
-
-BINDIR=`grep "#define[[:space:]]\+BINDIR" $CONFIG | \
-            sed 's,.*BINDIR[[:space:]]\+\"\([^"]\+\)".*,'${ROOT}'\1,'`
-SKELDIR=`grep "#define[[:space:]]\+SKELDIR" $CONFIG | \
-            sed 's,.*SKELDIR[[:space:]]\+\"\([^"]\+\)".*,'${ROOT}'\1,'`
-MANDIR=`grep "#define[[:space:]]\+MANDIR" $CONFIG | \
-            sed 's,.*MANDIR[[:space:]]\+\"\([^"]\+\)".*,'${ROOT}'\1,'`
-LIBDIR=`grep "#define[[:space:]]\+LIBDIR" $CONFIG | \
-            sed 's,.*LIBDIR[[:space:]]\+\"\([^"]\+\)".*,'${ROOT}'\1,'`
-CONFDIR=`grep "#define[[:space:]]\+CONFDIR" $CONFIG | \
-            sed 's,.*CONFDIR[[:space:]]\+\"\([^"]\+\)".*,'${ROOT}'\1,'`
-DOCDIR=`grep "#define[[:space:]]\+DOCDIR" $CONFIG | \
-            sed 's,.*DOCDIR[[:space:]]\+\"\([^"]\+\)".*,'${ROOT}'\1,'`
-DOCDOCDIR=`grep "#define[[:space:]]\+DOCDOCDIR" $CONFIG | \
-            sed 's,.*DOCDOCDIR[[:space:]]\+\"\([^"]\+\)".*,'${ROOT}'\1,'`
+CODE=$(grep "^#define" $CONFIG | sed -E 's/#define +([A-Za-z]+) +/\1=/')
+eval "$CODE"
 
 # CPPFLAGS=`grep "#define[[:space:]]\+CPPFLAGS" $CONFIG | sed 's,^.[^"]*,,'`
 # LDFLAGS=`grep "#define[[:space:]]\+LDFLAGS" $CONFIG | sed 's,^.[^"]*,,'`
