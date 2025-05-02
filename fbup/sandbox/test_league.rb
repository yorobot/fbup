###
##  to run use:
##    $ ruby sandbox/test_league.rb

$LOAD_PATH.unshift( './lib' )
require 'fbup'


pp Fbup::LeagueConfig.find_by( code: 'eng.1', season: '2024/25' ) 
pp Fbup::LeagueConfig.find_by( code: 'eng.1', season: '1988/89' ) 
    


puts "bye"


