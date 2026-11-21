class Fe < Formula
  desc "CLI tool for managing and releasing projects"
  homepage "https://github.com/flushwhy/fe"
  version "0.8.6"

  url "https://github.com/flushwhy/fe/releases/download/v0.8.6/fe-macos-amd64"
  sha256 "0afd3b21711f2377f2a0e08a6dc3583ba432bea32aa2735f32bc49752295ac57"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.8.6/fe-macos-arm64"
    sha256 "8fdb18a8f4d2bc8641e3eb1e6d81e6f79336b6d801328f5a27f50035b37d30ab"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
