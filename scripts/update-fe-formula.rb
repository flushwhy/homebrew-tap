#!/usr/bin/env ruby
# Update Fe's stable and versioned Homebrew formulae from GitHub releases.
require "json"

VERSIONED_LINE_LIMIT = 4
RELEASE_TAG = /\Av?(\d+)\.(\d+)\.(\d+)\z/
SHA256 = /\Asha256:[0-9a-f]{64}\z/

releases = JSON.parse(File.read(ARGV.fetch(0)))
stable = releases.reject { |release| release["draft"] || release["prerelease"] }.filter_map do |release|
  match = RELEASE_TAG.match(release.fetch("tag_name"))
  next unless match

  release.merge("_version_parts" => match.captures.map(&:to_i))
end

def version_key(release)
  release.fetch("_version_parts")
end

# Some older stable tags were published without macOS assets. Keep the newest
# release that Homebrew can actually install for each minor line.
installable = stable.select do |release|
  assets = release.fetch("assets").to_h { |asset| [asset.fetch("name"), asset] }
  intel = assets["fe-macos-amd64"] || assets["fe-macos-x64"]
  arm = assets["fe-macos-arm64"]
  valid = [intel, arm].all? { |asset| asset && asset["digest"]&.match?(SHA256) }
  puts "Skipping #{release.fetch("tag_name")}: missing macOS assets or SHA-256 digests" unless valid
  valid
end

def formula_for(release, class_name:, versioned: false)
  version = release.fetch("tag_name").sub(/\Av/, "")
  assets = release.fetch("assets").to_h { |asset| [asset.fetch("name"), asset] }
  intel = assets["fe-macos-amd64"] || assets["fe-macos-x64"]
  arm = assets.fetch("fe-macos-arm64")

  lines = []
  lines << "class #{class_name} < Formula"
  lines << "  desc \"CLI tool for managing and releasing projects\""
  lines << "  homepage \"https://github.com/flushwhy/fe\""
  lines << "  version \"#{version}\""
  lines << ""
  lines << "  keg_only :versioned_formula" if versioned
  lines << "  url \"#{intel.fetch("browser_download_url")}\""
  lines << "  sha256 \"#{intel.fetch("digest").delete_prefix("sha256:")}\""
  lines << ""
  lines << "  on_arm do"
  lines << "    url \"#{arm.fetch("browser_download_url")}\""
  lines << "    sha256 \"#{arm.fetch("digest").delete_prefix("sha256:")}\""
  lines << "  end"
  lines << ""
  lines << "  def install"
  lines << "    bin.install Dir[\"fe-macos-*\"].first => \"fe\""
  lines << "  end"
  lines << ""
  lines << "  test do"
  lines << '    assert_match "fe", shell_output("#{bin}/fe --help")'
  lines << "  end"
  lines << "end"
  lines.join("\n") + "\n"
end

abort "No installable stable Fe releases found" if installable.empty?
latest = installable.max_by { |release| version_key(release) }
File.write("Formula/fe.rb", formula_for(latest, class_name: "Fe"))
puts "Updated Formula/fe.rb to #{latest.fetch("tag_name")}"

version_lines = installable.map { |release| release.fetch("_version_parts").first(2) }.uniq.sort.last(VERSIONED_LINE_LIMIT)
keep_paths = version_lines.map do |major, minor|
  release = installable.select { |item| item.fetch("_version_parts").first(2) == [major, minor] }
                       .max_by { |item| version_key(item) }
  line = "#{major}.#{minor}"
  suffix = "#{major}#{minor}"
  path = "Formula/fe@#{line}.rb"
  File.write(path, formula_for(release, class_name: "FeAT#{suffix}", versioned: true))
  puts "Updated #{path} to #{release.fetch("tag_name")}"
  path
end

(Dir.glob("Formula/fe@*.rb") - keep_paths).each do |path|
  File.delete(path)
  puts "Removed obsolete formula #{path}"
end
