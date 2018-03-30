require 'optparse'

module ConsoleInputArguments

  class Processor

    def initialize(arguments)

      OptionParser.new do |opts|
        opts.banner = "Usage: ruby CreateImagesDocumentation.rb [options]"
        opts.separator "Builds up an html file with all components listed."
        opts.separator "Options:"

        help_options = "-h", "--help", "Prints this help"
        opts.on(*help_options) do
          puts opts.help.green
          exit
        end

        project_path_options = [
          '-p PATH',
          '--project_path PATH',
          'Project root folder'
        ]

        opts.on(*project_path_options) { |path| $options[:project_path] = path }

        template_path_options = [
          '-t PATH',
          '--template_path PATH',
          'html template file path'
        ]
        opts.on(*template_path_options) { |path| $options[:template_path] = path }

        github_repo_branch_options = [
          '-g PATH',
          '--github_branch_path PATH',
          'Project root path on github'
        ]
        opts.on(*github_repo_branch_options) { |path| $options[:github_repo_branch] = path }

        snapshots_folder_options = [
          '-s PATH',
          '--snapshots_folder PATH',
          'Snapshots folder relative to the project root'
        ]
        opts.on(*snapshots_folder_options) { |path| $options[:snapshots_path] = path }
      end.parse!

      if $options[:project_path].nil?
        puts('ERROR: You need to supply a project_path (-p or --project_path)'.red)
        exit
      end

      if $options[:template_path].nil?
        puts('ERROR: You need to supply a template path (-t or --template_path)'.red)
        exit
      end

      if $options[:github_repo_branch].nil?
        puts('ERROR: You need to supply a github repo (-g or --github_branch_path)'.red)
        exit
      end

      if $options[:snapshots_path].nil?
        puts('ERROR: You need to supply a snapshots_path (-s or --snapshots_path)'.red)
        exit
      end
    end
  end
end

class String
  def red;   "\e[31m#{self}\e[0m" end
  def green; "\e[32m#{self}\e[0m" end
end
