class FeAT07 < Formula
  desc "CLI tool for managing and releasing projects (0.7 maintenance line)"
  homepage "https://github.com/flushwhy/fe"
  version "0.7.5"

  keg_only :versioned_formula
  url "https://github.com/flushwhy/fe/releases/download/v0.7.5/fe-macos-amd64"
  sha256 "93f1ea6dfc246c32dd4b39b5d64b3add723f63f52ada0d9aa332f35246d047c5"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.7.5/fe-macos-arm64"
    sha256 "6841d6381abc056783e89b0cac60ef0e133ad1bbfd428a84264ffec6507b735e"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
