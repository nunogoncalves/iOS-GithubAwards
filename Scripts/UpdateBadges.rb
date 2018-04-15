#!/usr/bin/env ruby
#encoding: utf-8

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# This script is not being run.

swift_version_shell_cmd = `swift -version`
xcode_version_shell_cmd = `xcodebuild -version`

swift_output = "#{swift_version_shell_cmd}"
xcode_output = "#{xcode_version_shell_cmd}"

swift_version = swift_output.split("version ").last.split(" ").first
xcode_version = xcode_output.split(" ")[1]

def write_to_file(file_location, text)

  File.open(file_location, "w") do |file|
    file.write(text)
  end

end

def replace(text, after, before, newText)

  match = text[/#{after}(.*?)#{before}/m, 1]
  text.sub("#{after}#{match}#{before}", "#{after}#{newText}#{before}")
end

read_me_location = "README.md"
read_me_content = File.open(read_me_location).read

updated_read_me = replace(read_me_content, "badge/Xcode-", "-blue.svg", xcode_version)
updated_read_me = replace(updated_read_me, "badge/swift-", "-orange.svg", swift_version)

p updated_read_me

write_to_file(read_me_location, updated_read_me)
