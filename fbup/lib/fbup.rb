
require 'sportdb/writers'


require 'optparse'    ## command-line processing; check if included updstream?

########################
#  push & pull github scripts
require 'gitti'    ## note - requires git machinery



###
# our own code
require_relative 'fbup/version'

require_relative 'fbup/github_config'
require_relative 'fbup/github'   ## github helpers/update machinery


module Fbup
class  GitHubSync
  REPOS = GitHubConfig.new
  recs = read_csv( "#{SportDb::Module::Fbup.root}/config/openfootball.csv" )
  REPOS.add( recs )

## todo/check: find a better name for helper?
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
  datasets.each do |dataset|
    league_key = dataset[0]
    repo  = REPOS[ league_key ]
    ## pp repo
    if repo.nil?
       puts "!! ERROR - no repo config/path found for league >#{league_key}<; sorry"
       exit 1
    end

    repos <<  "#{repo['owner']}/#{repo['name']}"
  end

  pp repos
  repos.uniq   ## note: remove duplicates (e.g. europe or world or such)
end
end  #  class  GitHubSync
end  # module Fbup


require_relative 'fbup/main'



###
## todo/fix:  move more code into tool class or such? - why? why not?

## todo/check: find a better name for helper?
##   find_all_datasets, filter_datatsets - add alias(es???
##  queries (lik ARGV) e.g. ['at'] or ['eng', 'de'] etc. list of strings
def filter_datasets( datasets, queries=[] )
  ## find all matching leagues (that is, league keys)
  if queries.empty?  ## no filter - get all league keys
    datasets
  else
    datasets.find_all do |dataset|
                         found = false
                         ## note: normalize league key (remove dot and downcase)
                         league_key = dataset[0].gsub( '.', '' )
                         queries.each do |query|
                            q = query.gsub( '.', '' ).downcase
                            if league_key.start_with?( q )
                              found = true
                              break
                            end
                         end
                         found
                      end
  end
end




puts SportDb::Module::Fbup.banner   # say hello
