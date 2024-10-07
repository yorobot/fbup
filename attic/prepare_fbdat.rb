$LOAD_PATH.unshift( '../timezones/lib' )
$LOAD_PATH.unshift( '../footballdata/lib' )
require 'footballdata'


load_env   ## use dotenv (.env)


Webcache.root =  '/sports/cache'
## note -  free tier (tier one) plan - 10 requests/minute
##              (one request every 6 seconds 6*10=60 secs)
##     10 API calls per minute max.
##  note - default sleep (delay in secs) is 3 sec(s)

## change from 10 to 1 sec(s) for interactive use
Webget.config.sleep = 10

Footballdata.config.convert.out_dir =  '/sports/cache.api.fbdat'


# path = './leagues_fbdat.csv'
path = './leagues_fbdat.history.csv'
recs = read_csv( path )


recs.each do |rec|
  league   = rec['league']
  seasons  = rec['seasons'].split( /[ ]+/ )
  seasons.each_with_index do |season,i|
    puts "==> #{league} #{season} - #{i+1}/#{seasons.size}..."
    # Footballdata.schedule( league: league,  season: season )
    Footballdata.convert( league: league, season: season )
  end
end


puts "bye"
