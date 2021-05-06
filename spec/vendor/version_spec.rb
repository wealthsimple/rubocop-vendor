# frozen_string_literal: true

require 'git'
require 'keepachangelog'

RSpec.describe 'a published gem' do # rubocop:disable RSpec/DescribeClass
  def get_version(git, branch = 'HEAD')
    git.grep('STRING = ', 'lib/**/version.rb', object: branch)
       .map { |_sha, matches| matches.first[1] }
       .map(&method(:parse_version))
       .compact
       .first
  end

  def parse_version(string)
    string.match(/STRING = ['"](.*)['"]/)[1]
  end

  let(:git) { Git.open('.') }
  let(:head_version) { get_version(git, 'HEAD') }
  let(:main_version) { get_version(git, 'origin/main') }

  it 'has a version number' do
    expect(head_version).not_to be_nil
  end

  it 'has a bumped version committed' do
    is_main_branch = git.current_branch == 'main' || main_version.nil?
    skip('already on main branch, no need to compare versions') if is_main_branch

    expect(Gem::Version.new(head_version)).to be > Gem::Version.new(main_version)
  end

  it 'has a CHANGELOG.md file' do
    expect(File).to exist('CHANGELOG.md')
  end

  it 'has changelog entry for current version' do
    parser = Keepachangelog::MarkdownParser.load('CHANGELOG.md')

    expect(parser.parsed_content['versions'].keys).to include(start_with("#{head_version} - "))
  end
end
