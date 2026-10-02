require 'cocos'
require 'season-formats'


########################
#  push & pull github scripts
require 'gitti'    ## note - requires git machinery



###
# our own code
require_relative 'openfootball/version'

require_relative 'openfootball/github_config'
require_relative 'openfootball/github'   ## github helpers/update machinery

require_relative 'openfootball/league_config'   ## for "classic" custom basenames e.g. eng.1 => 1-premierleague etc.



module Openfootball
  def self._config
      @config ||= begin
             config = GitHubConfig.new
             ['openfootball-world', 'openfootball-europe'].each do |name|
                rows = read_csv( "#{root}/config/#{name}.csv" )
                config.add( rows )
             end
             config
            end
      @config
  end


  def self.find( code )  _config.find( code ); end
  class << self
     alias_method :[], :find
  end

  def self.find!( code )
    repo = find( code )
    raise ArgumentError,
        "[openfootball] no github repo config/path found for league code >#{code}<; sorry"   if repo.nil?
    repo
  end


  ## all-in-one convenience helper
  def self.mkpath( code:, season:,
                     suffix: nil, classic: true )
     repo = find!( code )
     repo.mkpath( code: code, season: season,
                     suffix: suffix, classic: classic )
  end


############
## note: datasets of format
##
## DATASETS = [
##   ['it.1',    %w[2020/21 2019/20]],
##  ['it.2',    %w[2019/20]],
##  ['es.1',    %w[2019/20]],
##  ['es.2',    %w[2019/20]],
## ]

  def self.find_repos( datasets )
    repos = []
    datasets.each do |code, seasons|
       repo  = find!( code )
       repos <<  "#{repo.owner}/#{repo.name}"
    end

    ## pp repos
    repos.uniq   ## note: remove duplicates (e.g. europe or world or such)
  end
end ## module Openfootball




puts Openfootball.banner   # say hello
