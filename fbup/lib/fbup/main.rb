
module Fbup

LEAGUE_NAMES_V2 = {
  'jp.1' => 'Japan | J1 League',
  'cn.1' => 'China | Super League', 
  'kz.1' => 'Kazakhstan | Premier League', 
  'eg.1' => 'Egypt | Premiership',
  'ma.1' => 'Morocco | Botola Pro 1',
  'dz.1' => 'Algeria | Ligue 1', 
  'il.1' => 'Israel | Premier League',
  'au.1' => 'Australia | A-League',  
############
## international 
##    note - will fetch team pages one-by-one too to get country (codes)
  'afl'    =>  'African Football League',
  'caf.cl' =>  'CAF Champions League', 
} 


def self.main( args=ARGV )

opts = {
  source_path: [],
  push:     false,
  ffwd:     false,
  dry:      false,  ## dry run (no write)
  test:     true,   ## sets push & ffwd to false
  debug:    true,
  file:     nil,
  test_dir:  './o',

  v1:       false,
  classic:  false,
  ## v2:       false,   ## v2 Football.TXT generation fromat
  ## flat:     false,   ##  use "flat" naming convention for datafile
}



parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] [args]"

    parser.on( "-p", "--[no-]push",
               "fast forward sync and commit & push changes to git repo - default is (#{opts[:push]})" ) do |push|
      opts[:push] = push
      if opts[:push]   ## note: autoset ffwd too if push == true
        opts[:ffwd] = true
        opts[:test] = false
      end
    end
    ## todo/check - add a --ffwd flag too - why? why not?

    parser.on( "-t", "--test",
                "test run; writing output to #{opts[:test_dir]} - default is #{opts[:test]}" ) do |test|
      opts[:test] = true
      opts[:push] = false
      opts[:ffwd] = false
    end

    parser.on( "--dry",
                "dry run; do NOT write - default is (#{opts[:dry]})" ) do |dry|
      opts[:dry] = dry
      opts[:test] = false
      opts[:push] = false    ### autoset push & ffwd - why? why not?
      opts[:ffwd] = false
    end

    parser.on( "-q", "--quiet",
               "less debug output/messages - default is (#{!opts[:debug]})" ) do |debug|
      opts[:debug] = false
    end

    parser.on( "--v1",
               "v1 text format - default is (#{opts[:v1]})" ) do |v1|
      opts[:v1] = true
    end

    parser.on( "--classic",
               "classic names; use season in directory NOT basename - default is (#{opts[:classic]})" ) do |classic|
      opts[:classic] = true
    end



    parser.on( "-I DIR", "--include DIR",
                "add directory to (source) search path - default is (#{opts[:source_path].join(',')})") do |dir|
      opts[:source_path] += path
    end

    parser.on( "-f FILE", "--file FILE",
                "read leagues (and seasons) via .csv file") do |file|
      opts[:file] = file
    end
end
parser.parse!( args )


if opts[:source_path].empty? &&
   File.exist?( '/sports/cache.api.fbdat')  &&
   File.exist?( '/sports/cache.wfb' )
     opts[:source_path] << '/sports/cache.api.fbdat'
     opts[:source_path] << '/sports/cache.wfb'
end

if opts[:source_path].empty?
  opts[:source_path]  = ['.']   ## use ./ as default
end



puts "OPTS:"
p opts
puts "ARGV:"
p args



source_path = opts[:source_path]

### get latest season with autofiller
##     todo use new LeaguesetAutofiller class - why? why not?
##    or move code of autofiller here - why? why not?
##
autofiller = ->(league_query) {           
  Leagueset.autofiller( league_query, source_path: source_path )
} 

datasets =   if opts[:file]
                  read_leagueset( opts[:file], autofill: autofiller )
             else
                  parse_leagueset_args( args, autofill: autofiller )
             end

puts "datasets:"
pp datasets



root_dir =  if opts[:test]
               opts[:test_dir]
            else
               GitHubSync.root   # e.g. "/sports"
            end

puts "  (output) root_dir: >#{root_dir}<"

repos = GitHubSync.find_repos( datasets )
puts "  #{repos.size} repo(s):"
pp repos
sync  =  GitHubSync.new( repos )

puts "  sync:"
pp sync



sync.git_fast_forward_if_clean    if opts[:ffwd]


### step 0 - validate and fill-in seasons etc.
##
##  todo/fix - remove fill-in seasons from validate!!
##                 use new autofill on init!!!
datasets.validate!( source_path: source_path )


##
## note - use league_query (or league_qkey or _querykey) or such
##                for user supplied key to compute/find the canoncial league code

datasets.each do |league_query, seasons|
    puts "==> gen #{league_query} - #{seasons.size} seasons(s)..."


    seasons.each do |season|
      ## note - league info requires season 
      ##          PLUS use (canoncial) league code from info!!!
      league_info = LeagueCodes.find_by( code: league_query, season: season )
      pp league_info

      league_code  = league_info[ 'code' ]
      league_name  = league_info[ 'name' ]       # e.g. Brasileiro Série A

      ### todo/fix - move basename out of league_info
      ###               make it github/openfootball "legacy" code
      ## basename     = league_info[ 'basename' ]   #.e.g  1-seriea
  
    
      filename = "#{season.to_path}/#{league_code}.csv"
      path = find_file( filename, path: source_path )

      ### get matches
      puts "  ---> reading matches in #{path} ..."
      matches = SportDb::CsvMatchParser.read( path )
      puts "     #{matches.size} matches"


      ## get repo config for flags and more
      repo  = GitHubSync::REPOS[ league_code ]
      flags = repo['flags'] || {}
      classic_flag = flags['classic'] || false


      ## build
      txt =  if opts[:v1]
               ## todo - change upstream build to build_v1
               SportDb::TxtMatchWriter.build( matches )
             else 
               SportDb::TxtMatchWriter.build_v2( matches )
             end

      puts txt   if opts[:debug]


   
      basename = nil
      if classic_flag || opts[:classic]
         league_config = LeagueConfig.find_by( code: league_query, season: season )
         if league_config.nil?
            puts "!! ERROR - basename league config required for classic format; no config found for #{league_query} #{season}; sorry"
            exit 1
         end
         basename  = league_config['basename']        
      else 
         ## change base name to league key
         ##   todo - fix - make gsub smarter
         ##    change at.cup to at_cup - why? why not?
         basename = league_code.gsub( '.', '' )
         ## bonus - add quick fix for new league name overwrites
         league_name = LEAGUE_NAMES_V2[league_code] || league_name
      end



      buf = String.new
      buf << "= #{league_name} #{season}\n\n"
      buf << txt
    
      repo_path = "#{repo['owner']}/#{repo['name']}"
      repo_path << "/#{repo['path']}"    if repo['path']  ## note: do NOT forget to add optional extra path!!!

    
      outpath = "#{root_dir}/#{repo_path}"


      outpath +=  if classic_flag || opts[:classic]
                     "/#{season.to_path}/#{basename}.txt"
                  else
                     ## note - add season "inline" (to basename) or use dir
                     "/#{season.to_path}_#{basename}.txt"
                  end


      if opts[:dry]
        puts "   (dry) writing to >#{outpath}<..."
      else
        write_text( outpath, buf )
      end
    end
end

sync.git_push_if_changes   if opts[:push]

end  # method self.main
end  # module Fbup
