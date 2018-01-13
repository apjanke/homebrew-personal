class DartFromSourceHead < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"
  conflicts_with "dart-sdk/dart/dart", :because => "They install the same program"
  head "https://github.com/dart-lang/sdk.git"
  # Note: User must install depot-tools --HEAD. Sorry for the inconvenience.
  depends_on "google-depot-tools"
  
  def install
    depot_tools = Formula["google-depot-tools"].libexec
    ENV.prepend_path "PATH", depot_tools

    args = ["--mode", "release"]
    if MacOS.prefer_64_bit?
      args << "--arch x64"
      release_subdir = "ReleaseX64"
    else
      args << "--arch x86"
      release_subdir = "ReleaseIA32"
    end
    system("./tools/build.py", *args)

    cd("xcodebuild/#{release_subdir}/dart_sdk")
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
  end

  def shim_script(target)
    <<~EOS
      #!/usr/bin/env bash
      exec "#{prefix}/#{target}" "$@"
    EOS
  end

  def caveats; <<~EOS
    Please note the path to the Dart SDK:
      #{opt_libexec}
    EOS
  end

  test do
    (testpath/"sample.dart").write <<~EOS
      void main() {
        print(r"test message");
      }
    EOS

    assert_equal "test message\n", shell_output("#{bin}/dart sample.dart")
  end
end
