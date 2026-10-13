class Fe < Formula
  desc "CLI tool for managing and releasing projects"
  homepage "https://github.com/flushwhy/fe"
  version "0.4.0"

  url "https://github.com/flushwhy/fe/releases/download/v0.4.0/fe-macos-x64"
  sha256 "9a9bad3d1fd30e9c9fcdd89f5d672a03ae03ca98c5be2ecc88eab78a8d349424"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.4.0/fe-macos-arm64"
    sha256 "0750f49b7ec1d30c1916fa3e20e5cf650284ef204bf5955e022103ba11d57f3c"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
