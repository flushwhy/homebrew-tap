class Fe < Formula
  desc "CLI tool for managing and releasing projects"
  homepage "https://github.com/flushwhy/fe"
  version "0.8.5"

  url "https://github.com/flushwhy/fe/releases/download/v0.8.5/fe-macos-amd64"
  sha256 "c6eee587f67447b4e5f640700ed5d3827db55587ad90f9b47768466792175674"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.8.5/fe-macos-arm64"
    sha256 "3b189902fd9583f6ec26a58994f102b4e8276454a4319e6c5abdacb923761558"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
