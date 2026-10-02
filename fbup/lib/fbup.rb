

## use latest if available
$LOAD_PATH.unshift( '/sports/yorobot/fbup/openfootball/lib' )
require 'openfootball'


require 'sportdb/writers'
require 'leagues'   ## pulls-in find_league_info, etc.


###
# our own code
require_relative 'fbup/version'
require_relative 'fbup/main'





puts SportDb::Module::Fbup.banner   # say hello
