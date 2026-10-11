#!/usr/bin/env ruby
# Update Formula/fe.rb using GitHub's published release metadata.
require "json"

release_path = ARGV.fetch(0)
release = JSON.parse(File.read(release_path))
abort "Latest release is a draft or prerelease" if release["draft"] || release["prerelease"]

version = release.fetch("tag_name").sub(/\Av/, "")
abort "Unexpected version tag: #{version}" unless version.match?(/\A\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?\z/)

assets = release.fetch("assets").to_h { |asset| [asset.fetch("name"), asset] }
required = {
  "fe-macos-x64" => "Intel macOS",
  "fe-macos-arm64" => "Apple Silicon macOS"
}

required.each do |name, platform|
  asset = assets[name]
  abort "Release #{version} is missing required asset #{name} (#{platform})" unless asset
  digest = asset["digest"]
  abort "Asset #{name} has no GitHub SHA-256 digest; refusing to guess" unless digest&.match?(/\Asha256:[0-9a-f]{64}\z/)
end

intel = assets.fetch("fe-macos-x64")
arm = assets.fetch("fe-macos-arm64")
formula = <<~RUBY
  class Fe < Formula
    desc "CLI tool for managing and releasing projects"
    homepage "https://github.com/flushwhy/fe"
    version "#{version}"

    url "#{intel.fetch("browser_download_url")}"
    sha256 "#{intel.fetch("digest").delete_prefix("sha256:")}"

    on_arm do
      url "#{arm.fetch("browser_download_url")}"
      sha256 "#{arm.fetch("digest").delete_prefix("sha256:")}"
    end

    def install
      bin.install Dir["fe-macos-*"].first => "fe"
    end

    test do
      assert_match "fe", shell_output("\#{bin}/fe --help")
    end
  end
RUBY

path = "Formula/fe.rb"
unless File.exist?(path) && File.read(path) == formula
  File.write(path, formula)
  puts "Updated #{path} to fe #{version}"
else
  puts "Formula already matches fe #{version}"
end
