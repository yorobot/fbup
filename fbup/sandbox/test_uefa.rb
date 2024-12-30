###
## todo/fix
##    move to/make into proper unit test!!!


###
##  to run use:
##    $ ruby sandbox/test_uefa.rb

$LOAD_PATH.unshift( './lib' )
require 'fbup'



require 'fifa'


uefa = Uefa.countries



season = '2024/25'


uefa.each do |country|
   key = country.key
   ## use cup for liechtenstein (li)
   league_code =  if key == 'li' 
                       "#{key}.cup" 
                  else 
                       "#{key}.1"
                  end

   league_info = find_league_info( league_code )

   if league_info.nil?
      puts "!! #{country.key} #{country.name} - no league info found"
   else

      repo = Fbup::GitHubSync::REPOS[ league_code ]
      if repo.nil?
         puts "!! #{country.key} #{country.name} - no repo (info) found"
      else
        puts "  OK #{country.key} #{country.name}"
      end
      ## pp league_info
   end
end


puts "bye"

__END__

OK kz Kazakhstan
OK al Albania
OK ad Andorra
OK at Austria
OK by Belarus
OK be Belgium
OK ba Bosnia and Herzegovina
OK bg Bulgaria
OK hr Croatia
OK cy Cyprus
OK cz Czech Republic
OK dk Denmark
OK ee Estonia
OK es Spain
OK fi Finland
OK fr France
OK de Germany
OK gr Greece
OK hu Hungary
OK is Iceland
OK it Italy
OK ie Ireland
OK lv Latvia
OK li Liechtenstein
OK lt Lithuania
OK lu Luxembourg
OK mk North Macedonia
OK mt Malta
OK md Moldova
OK me Montenegro
OK nl Netherlands
OK no Norway
OK pl Poland
OK pt Portugal
OK ro Romania
OK ru Russia
OK sm San Marino
OK rs Serbia
OK sk Slovakia
OK si Slovenia
OK se Sweden
OK ch Switzerland
OK tr Turkey
OK ua Ukraine
OK kos Kosovo
OK am Armenia
OK az Azerbaijan
OK ge Georgia
OK fo Faroe Islands
OK gi Gibraltar
OK eng England
OK wal Wales
OK sco Scotland
OK nir Northern Ireland
OK il Israel

