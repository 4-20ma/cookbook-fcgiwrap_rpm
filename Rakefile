#!/usr/bin/env rake
# encoding: utf-8
require 'bundler/setup'
require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Style guide for this Rakefile:
# - place default task at the beginning of the file
# - individual tasks are listed in alphabetical order

#---------------------------------------------- automatically run by travis-ci
task :default => [:build_ci]

desc 'Builds the package for ci server.'
task :build_ci do
  Rake::Task[:knife].invoke
  Rake::Task[:rubocop].invoke
  Rake::Task[:foodcritic].invoke
  Rake::Task[:unit].invoke
end # task

#------------------------------------------------------------------- changelog
# TODO: improve the following:
# - remove bump version commits
# - prepend to CHANGELOG without using changelog.tmp
desc 'Updates changelog with commit messages'
task :changelog, [:tag1, :tag2] do |t, args|
  args.with_defaults(:tag1 => 'v0.1.0', :tag2 => 'HEAD')
  date = `git log -1 --format=%ad #{args[:tag2]} --date=short`
  title = %(#{args[:tag2].gsub(/^v/, '')} / #{date}).chomp
  underline = '-' * title.size
  url = 'https://github.com/4-20ma'
  format = %(- "'`'"TYPE"'`'" - %s | [view](#{url}/$basename/commit/%h))
  file = 'changelog.tmp'
  sh <<-EOF
    remote=$(git config --get branch.master.remote)
    url=$(git config --get remote.$remote.url)
    basename=$(basename "$url" .git)
    echo "#{title}\n#{underline}\n" > #{file}
    git log #{args[:tag1]}..#{args[:tag2]} --no-merges \
      --pretty=format:"#{format}" >> #{file}
  EOF
end # task

#------------------------------------------------------------------ unit tests
task :chefspec => [:unit]
RSpec::Core::RakeTask.new(:unit) do |t|
  file_list = FileList['spec/**/*_spec.rb']

  %w(integration).each do |exclude|
    file_list = file_list.exclude("spec/#{exclude}/**/*_spec.rb")
  end # %w(...).each

  t.pattern = file_list

  t.rspec_opts = [].tap do |a|
    a.push('-I spec/unit/support')
    a.push('--color')
    a.push('--format progress')
  end.join(' ')
end # RSpec::Core::RakeTask

#-------------------------------------------------- cookbook lint/style checks
FoodCritic::Rake::LintTask.new do |t|
  # exclude tags by using ~FC002 notation within :tags array
  t.options = {
    :fail_tags => %w(any),
    :include_rules => ['spec/foodcritic'],
    :tags => %w()
  }
end # FoodCritic::Rake::LintTask.new

namespace :foodcritic do
  desc 'Updates 3rd-party foodcritic rules.'
  task :update do
    sh 'git submodule update --init --recursive'
  end # task
end # namespace

#----------------------------------------------------------- integration tests
begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new

  desc 'Run all test instances'
  task :kitchen => ['kitchen:all']
rescue LoadError
  STDOUT.puts '[WARN] Kitchen::RakeTasks not loaded'
end

#--------------------------------------------------------------- syntax checks
desc 'Runs knife cookbook syntax checks against the cookbook.'
task :knife do
  sh 'bundle exec knife cookbook test --all --cookbook-path .'
end # task

#-------------------------------------------------------------- release/tagger
begin
  require 'emeril/rake_tasks'
  Emeril::RakeTasks.new do |t|
    # turn on debug logging
    t.config[:logger].level = :debug

    # set a category for this cookbook
    t.config[:category] = 'Package Management'

    # explicitly indicate whether to publish to chef supermarket
    t.config[:publish_to_supermarket] = true
  end
rescue LoadError
  STDOUT.puts '[WARN] Emeril::RakeTasks not loaded'
end

#------------------------------------------------------ ruby lint/style checks
desc 'Runs rubocop lint tool against the cookbook.'
task :rubocop do
  RuboCop::RakeTask.new(:rubocop) do |t|
    # t.fail_on_error = true
  end
end # task
