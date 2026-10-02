# openfootball - config settings for openfootball repos @ github


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/openfootball](https://rubygems.org/gems/openfootball)
* rdoc  :: [rubydoc.info/gems/openfootball](http://rubydoc.info/gems/openfootball)



## Usage

incl. mapping of league codes to repos
and directory style and custom basename and more


```ruby
require 'openfootball'

## "classic"-style repo layout w/ season directories & custom league basenames
at = Openfootball['at']    ## same as Openfootball.find( 'at' )
pp at
pp at.mkpath( code: 'at.1',   season: '2026/27' )
#=> "openfootball/austria/2026-27/1-bundesliga.txt"
pp at.mkpath( code: 'at.1',   season: '2026/27', suffix: 'full' )
#=> "openfootball/austria/2026-27/1-bundesliga-full.txt"
pp at.mkpath( code: 'at.cup', season: '2026/27' )
#=> "openfootball/austria/2026-27/cup.txt

#-or-
pp Openfootball.mkpath( code: 'at.1',   season: '2026/27' )
#=> "openfootball/austria/2026-27/1-bundesliga.txt"
pp Openfootball.mkpath( code: 'at.1',   season: '2026/27', suffix: 'full' )
#=> "openfootball/austria/2026-27/1-bundesliga-full.txt"
pp Openfootball.mkpath( code: 'at.cup', season: '2026/27' )
#=> "openfootball/austria/2026-27/cup.txt



## "flat"-style repo layout
fr = Openfootball['fr']   ## same as Openfootball.find( 'fr' )
pp fr
pp fr.mkpath( code: 'fr.1',   season: '2026/27' )
#=> "openfootball/europe/france/2026-27_fr1.txt"
pp fr.mkpath( code: 'fr.1',   season: '2026/27', suffix: 'full' )
#=> "openfootball/europe/france/2026-27_fr1-full.txt"
pp fr.mkpath( code: 'fr.cup', season: '2026/27' )
#=> "openfootball/europe/france/2026-27_frcup.txt"

#-or-
pp Openfootball.mkpath( code: 'fr.1',   season: '2026/27' )
#=> "openfootball/europe/france/2026-27_fr1.txt"
pp Openfootball.mkpath( code: 'fr.1',   season: '2026/27', suffix: 'full' )
#=> "openfootball/europe/france/2026-27_fr1-full.txt"
pp Openfootball.mkpath( code: 'fr.cup', season: '2026/27' )
#=> "openfootball/europe/france/2026-27_frcup.txt"
```





## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)
