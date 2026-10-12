class Fe < Formula
  desc "CLI tool for managing and releasing projects"
  homepage "https://github.com/flushwhy/fe"
  version "0.3.2"

  url "https://github.com/flushwhy/fe/releases/download/v0.3.2/fe-macos-x64"
  sha256 "b85968dd2dff362414c9f7465c09e1361b442bf97004df0fbe58e66587855cf1"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.3.2/fe-macos-arm64"
    sha256 "35a51438afb705498a37f0143239563201788890a20a6c1fc5192ec738209ad6"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
