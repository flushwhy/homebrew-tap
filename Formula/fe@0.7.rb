class FeAT07 < Formula
  desc "CLI tool for managing and releasing projects (0.7 maintenance line)"
  homepage "https://github.com/flushwhy/fe"
  version "0.7.0"

  keg_only :versioned_formula

  url "https://github.com/flushwhy/fe/releases/download/v0.7.0/fe-macos-x64"
  sha256 "2afb73b3c78135baf14ce4037c3033726a577e18f41e1450f67d7e1e9c89f706"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.7.0/fe-macos-arm64"
    sha256 "5aeb45b009aa603968eba74dc58c8b016d54a5642f01232d5901fa3c0274d2eb"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
