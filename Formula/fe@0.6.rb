class FeAT06 < Formula
  desc "CLI tool for managing and releasing projects (0.6 maintenance line)"
  homepage "https://github.com/flushwhy/fe"
  version "0.6.0"

  keg_only :versioned_formula
  url "https://github.com/flushwhy/fe/releases/download/v0.6.0/fe-macos-amd64"
  sha256 "7e659f3fa8975a92e1a34e848a3654c0e33236682513a4f54c84f3948ce8f3cd"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.6.0/fe-macos-arm64"
    sha256 "0672570988345b7f7c5c3f3f457bf34332f868f70936140641d6ccd53be747f4"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
