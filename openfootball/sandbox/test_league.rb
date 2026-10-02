###
##  to run use:
##    $ ruby sandbox/test_league.rb

$LOAD_PATH.unshift( './lib' )
require 'openfootball'


pp Fbup::LeagueConfig.find_by( code: 'eng.1', season: '2024/25' )
pp Fbup::LeagueConfig.find_by( code: 'eng.1', season: '1988/89' )

pp Fbup::LeagueConfig.find_by( code: 'eng.facup', season: '2024/25' )


pp Fbup::LeagueConfig.find_by( code: 'de.4.w', season: '2025/26' )
pp Fbup::LeagueConfig.find_by( code: 'de.4.west', season: '2025/26' )
pp Fbup::LeagueConfig.find_by( code: 'DE4WEST', season: '2025/26' )
pp Fbup::LeagueConfig.find_by( code: 'DE 4 WEST', season: '2025/26' )
pp Fbup::LeagueConfig.find_by( code: 'DE 4/WEST', season: '2025/26' )


puts "bye"
