class Fe < Formula
  desc "CLI tool for managing and releasing projects"
  homepage "https://github.com/flushwhy/fe"
  version "0.3.0"

  url "https://github.com/flushwhy/fe/releases/download/v0.3.0/fe-macos-x64"
  sha256 "7de1f3f215ae8d7ed5e692766f620cdf0432bbfe84389bddad2f302975fee942"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.3.0/fe-macos-arm64"
    sha256 "495afeecf1e73faa934d98b83190d802e629cf153fd06b1e8922bb2727868758"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
