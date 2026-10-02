##########
# to run use:
#   $ ruby sandbox/read_github.rb

$LOAD_PATH.unshift( './lib' )
require 'openfootball'



repos = Openfootball::GitHubConfig.new
repos.add( read_csv( './config/openfootball-world.csv' ))
repos.add( read_csv( './config/openfootball-europe.csv' ))
pp repos


pp repos['at.1']
pp repos['at.3.o']
pp repos['at.cup']

pp repos['eng.3']
pp repos['eng.5']

pp repos['fr.1']
pp repos['fr.cup']

pp repos['uefa.cl']
pp repos['uefa.champs']


pp repos['at.1'].classic?
pp repos['fr.1'].classic?


at = repos['at']
pp at
pp at.mkpath( code: 'at.1',   season: '2026/27' )
pp at.mkpath( code: 'at.1',   season: '2026/27', suffix: 'full' )
pp at.mkpath( code: 'at.cup', season: '2026/27' )
#=> "openfootball/austria/2026-27/1-bundesliga.txt"
#=> "openfootball/austria/2026-27/1-bundesliga-full.txt"
#=> "openfootball/austria/2026-27/cup.txt


fr = repos['fr']
pp fr
pp fr.mkpath( code: 'fr.1',   season: '2026/27' )
pp fr.mkpath( code: 'fr.1',   season: '2026/27', suffix: 'full' )
pp fr.mkpath( code: 'fr.cup', season: '2026/27' )
#=> "openfootball/europe/france/2026-27_fr1.txt"
#=> "openfootball/europe/france/2026-27_fr1-full.txt"
#=> "openfootball/europe/france/2026-27_frcup.txt"

puts "bye"