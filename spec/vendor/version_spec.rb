# frozen_string_literal: true

require 'git'
require 'keepachangelog'

RSpec.describe 'a published gem' do # rubocop:disable RSpec/DescribeClass
  def get_version(git, branch = 'HEAD')
    git.grep('VERSION = ', 'lib/**/version.rb', { object: branch })
       .map { |_sha, matches| matches.first[1] }
       .filter_map { |str| parse_version(str) }
       .first
  rescue Git::GitExecuteError
    # Catches failures for branch name being master
    nil
  end

  def parse_version(string)
    string.match(/VERSION = ['"](.*)['"]/)[1]
  end

  def main_branch
    @main_branch ||=
      if git.branches['origin/main']
        'origin/main'
      elsif git.branches['origin/master']
        'origin/master'
      else
        raise StandardError,
              <<~ERROR
                Couldn't determine main branch.
                Does 'origin/main' or 'origin/master' need to be fetched?
              ERROR
      end
  end

  def needs_version_bump?
    base = git.merge_base(main_branch, 'HEAD').first&.sha
    base ||= main_branch
    git.diff(base, 'HEAD').any? do |diff|
      not_gemfile?(diff) && not_lockfile?(diff) && not_ci_file?(diff)
    end
  end

  def not_lockfile?(diff)
    diff.path != 'Gemfile.lock'
  end

  def not_gemfile?(diff)
    diff.path != 'Gemfile'
  end

  def not_ci_file?(diff)
    !diff.path.start_with?('.github/')
  end

  let(:git) { Git.open('.') }
  let(:head_version) { get_version(git, 'HEAD') }

  it 'has a version number' do
    expect(head_version).not_to be_nil
  end

  it 'has a bumped version committed' do
    main_version = get_version(git, main_branch)
    skip('first time publishing, no need to compare versions') if main_version.nil?

    is_main_branch = git.current_branch == main_branch
    skip('already on main branch, no need to compare versions') if is_main_branch

    skip('Diff only contains non-code changes, no need to bump version') unless needs_version_bump?

    expect(Gem::Version.new(head_version)).to be > Gem::Version.new(main_version)
  end

  it 'has a CHANGELOG.md file' do
    expect(File).to exist('CHANGELOG.md')
  end

  it 'has changelog entry for current version' do
    parser = Keepachangelog::MarkdownParser.load('CHANGELOG.md')

    expect(parser.parsed_content['versions'].keys).to include(start_with(head_version))
  end
end
