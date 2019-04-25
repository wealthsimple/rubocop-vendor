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
  let(:master_version) { get_version(git, 'origin/master') }

  it 'has a version number' do
    expect(head_version).not_to be_nil
  end

  it 'has a bumped version committed' do
    is_master_branch = git.current_branch == 'master' || master_version.nil?
    skip('already on master branch, no need to compare versions') if is_master_branch

    expect(Gem::Version.new(head_version)).to be > Gem::Version.new(master_version)
  end

  it 'has a CHANGELOG.md file' do
    expect(File).to exist('CHANGELOG.md')
  end

  it 'has changelog entry for current version' do
    parser = Keepachangelog::MarkdownParser.load('CHANGELOG.md')

    expect(parser.parsed_content['versions'].keys).to include(start_with("#{head_version} - "))
  end
end
