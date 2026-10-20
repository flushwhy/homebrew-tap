class Fe < Formula
  desc "CLI tool for managing and releasing projects"
  homepage "https://github.com/flushwhy/fe"
  version "0.6.0"

  url "https://github.com/flushwhy/fe/releases/download/v0.6.0/fe-macos-x64"
  sha256 "bba95b1ff6c93d2825129faaa12854b8b69db52dda0c5f946b625a96e4980774"

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
