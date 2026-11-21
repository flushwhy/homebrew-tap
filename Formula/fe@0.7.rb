class FeAT07 < Formula
  desc "CLI tool for managing and releasing projects (0.7 maintenance line)"
  homepage "https://github.com/flushwhy/fe"
  version "0.7.6"

  keg_only :versioned_formula
  url "https://github.com/flushwhy/fe/releases/download/v0.7.6/fe-macos-amd64"
  sha256 "c722567ccaeb562b88780ec88b9debd155e1a5e31506aa6c7eeec7e23297bb05"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.7.6/fe-macos-arm64"
    sha256 "da5540b1a138b5ae89f97bee69e0b05367513a2260b270fcbc3efa6363ae7a06"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
