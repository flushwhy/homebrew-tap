class FeAT05 < Formula
  desc "CLI tool for managing and releasing projects (0.5 maintenance line)"
  homepage "https://github.com/flushwhy/fe"
  version "0.5.0"

  keg_only :versioned_formula
  url "https://github.com/flushwhy/fe/releases/download/v0.5.0/fe-macos-amd64"
  sha256 "65228a2f71749de4731c9f2ddfba9256bc9a779b248d94e1f29d244b20548c72"

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
