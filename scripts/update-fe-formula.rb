#!/usr/bin/env ruby
# Update Fe's stable and versioned Homebrew formulae from GitHub releases.
require "json"

VERSIONED_LINES = %w[0.7 0.8].freeze
RELEASE_TAG = /\\Av?(\\d+)\\.(\\d+)\\.(\\d+)\\z/

releases = JSON.parse(File.read(ARGV.fetch(0)))
stable = releases.reject { |release| release["draft"] || release["prerelease"] }.filter_map do |release|
  match = RELEASE_TAG.match(release.fetch("tag_name"))
  next unless match

  release.merge("_version_parts" => match.captures.map(&:to_i))
end

def version_key(release)
  release.fetch("_version_parts")
end

def formula_for(release, class_name:, versioned: false)
  version = release.fetch("tag_name").sub(/\\Av/, "")
  assets = release.fetch("assets").to_h { |asset| [asset.fetch("name"), asset] }

  intel = assets["fe-macos-amd64"] || assets["fe-macos-x64"]
  arm = assets["fe-macos-arm64"]
  { "fe-macos-amd64 or fe-macos-x64" => intel, "fe-macos-arm64" => arm }.each do |name, asset|
    abort "#{release.fetch("tag_name")} is missing #{name}" unless asset
    abort "#{name} has no verified SHA-256 digest" unless asset["digest"]&.match?(/\\Asha256:[0-9a-f]{64}\\z/)
  end

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
  lines << "    assert_match \"fe\", shell_output(\"#{bin}/fe --help\")"
  lines << "  end"
  lines << "end"
  lines.join("\\n") + "\\n"
end

abort "No stable semantic-versioned Fe releases found" if stable.empty?
latest = stable.max_by { |release| version_key(release) }
File.write("Formula/fe.rb", formula_for(latest, class_name: "Fe"))
puts "Updated Formula/fe.rb to #{latest.fetch("tag_name")}"

VERSIONED_LINES.each do |line|
  release = stable.select { |item| item.fetch("_version_parts").first(2).join(".") == line }
                  .max_by { |item| version_key(item) }
  abort "No stable release found for maintenance line #{line}" unless release

  suffix = line.split(".").map(&:to_i).join
  path = "Formula/fe@#{line}.rb"
  File.write(path, formula_for(release, class_name: "FeAT#{suffix}", versioned: true))
  puts "Updated #{path} to #{release.fetch("tag_name")}"
end
