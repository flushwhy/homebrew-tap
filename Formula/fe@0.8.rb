class FeAT08 < Formula
  desc "CLI tool for managing and releasing projects (0.8 maintenance line)"
  homepage "https://github.com/flushwhy/fe"
  version "0.8.3"

  keg_only :versioned_formula
  url "https://github.com/flushwhy/fe/releases/download/v0.8.3/fe-macos-amd64"
  sha256 "78ce317360ca18fdce89b7e83eaa9898e116d20e589da9e551fbd2684eb70e19"

  on_arm do
    url "https://github.com/flushwhy/fe/releases/download/v0.8.3/fe-macos-arm64"
    sha256 "9fd9e48f203147b5b90b0148452c5d77b0111d50fa98923491852b9effede538"
  end

  def install
    bin.install Dir["fe-macos-*"].first => "fe"
  end

  test do
    assert_match "fe", shell_output("#{bin}/fe --help")
  end
end
