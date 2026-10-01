
require 'leagues'   ## pulls-in find_league_info, etc.

########################
#  push & pull github scripts
require 'gitti'    ## note - requires git machinery



###
# our own code
require_relative 'openfootball/version'

require_relative 'openfootball/github_config'
require_relative 'openfootball/github'   ## github helpers/update machinery

require_relative 'openfootball/league_config'   ## for "classic" custom basenames e.g. eng.1 => 1-premierleague etc.



puts Openfootball.banner   # say hello
