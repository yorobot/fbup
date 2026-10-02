##########
# to run use:
#   $ ruby sandbox/test_readme.rb

$LOAD_PATH.unshift( './lib' )
require 'openfootball'


require 'openfootball'

## "classic"-style repo layout w/ season directories & custom league basenames
at = Openfootball['at']
pp at
at = Openfootball.find( 'at' )
pp at
pp at.mkpath( code: 'at.1',   season: '2026/27' )
pp at.mkpath( code: 'at.1',   season: '2026/27', suffix: 'full' )
pp at.mkpath( code: 'at.cup', season: '2026/27' )

#-or-
pp Openfootball.mkpath( code: 'at.1',   season: '2026/27' )
pp Openfootball.mkpath( code: 'at.1',   season: '2026/27', suffix: 'full' )
pp Openfootball.mkpath( code: 'at.cup', season: '2026/27' )

pp Openfootball.mkpath( code: 'at.1',   season: '2026/27', classic: false )
pp Openfootball.mkpath( code: 'at.1',   season: '2026/27', suffix: 'full', classic: false )
pp Openfootball.mkpath( code: 'at.cup', season: '2026/27', classic: false )


## "flat"-style repo layout
fr = Openfootball['fr']
pp fr
fr = Openfootball.find( 'fr' )
pp fr
pp fr.mkpath( code: 'fr.1',   season: '2026/27' )
pp fr.mkpath( code: 'fr.1',   season: '2026/27', suffix: 'full' )
pp fr.mkpath( code: 'fr.cup', season: '2026/27' )

#-or-
pp Openfootball.mkpath( code: 'fr.1',   season: '2026/27' )
pp Openfootball.mkpath( code: 'fr.1',   season: '2026/27', suffix: 'full' )
pp Openfootball.mkpath( code: 'fr.cup', season: '2026/27' )


datasets = [
   ['it.1',    %w[2020/21 2019/20]],
   ['it.2',    %w[2019/20]],
   ['es.1',    %w[2019/20]],
   ['es.2',    %w[2019/20]]]

pp Openfootball.find_repos( datasets )


puts "bye"