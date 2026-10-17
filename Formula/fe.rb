class Fe < Formula
  desc "CLI tool for managing and releasing projects"
  homepage "https://github.com/flushwhy/fe"
  version "0.5.0"

  url "https://github.com/flushwhy/fe/releases/download/v0.5.0/fe-macos-x64"
  sha256 "2dffe1edc419a34406dfe9fbdc0173a0f7c5a12acaadc1d1083c647ffd263f5d"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.5.0/fe-macos-arm64"
    sha256 "d410e749cd6005ec5f5912965cff45a02453e8b0707157e427a2c6ecf8a7e1e5"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
