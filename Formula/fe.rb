class Fe < Formula
  desc "CLI tool for managing and releasing projects"
  homepage "https://github.com/flushwhy/fe"
  version "0.8.2"

  url "https://github.com/flushwhy/fe/releases/download/v0.8.2/fe-macos-amd64"
  sha256 "1e0bea5732bc43e92c03fa35c4db9f9d3d88f9d94810c2d5ee52ba5227ff909a"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.8.2/fe-macos-arm64"
    sha256 "80be0eca41d9b9c9585cc79b9258a4db965b5a9fbb4feb931a7ab20a2a3e7e89"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
