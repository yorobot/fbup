
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


datasets =   if opts[:file]
                  read_leagueset( opts[:file] )
             else
                  parse_leagueset_args( args )
             end

puts "datasets:"
pp datasets


source_path = opts[:source_path]

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
datasets.validate!( source_path: source_path )


datasets.each do |league_key, seasons|
    puts "==> gen #{league_key} - #{seasons.size} seasons(s)..."

    league_info = find_league_info( league_key )
    pp league_info

    seasons.each do |season|
      filename = "#{season.to_path}/#{league_key}.csv"
      path = find_file( filename, path: source_path )

      ### get matches
      puts "  ---> reading matches in #{path} ..."
      matches = SportDb::CsvMatchParser.read( path )
      puts "     #{matches.size} matches"


      ## get repo config for flags and more
      repo  = GitHubSync::REPOS[ league_key ]
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


      league_name  = league_info[ :name ]      # e.g. Brasileiro Série A
      basename     = league_info[ :basename]   #.e.g  1-seriea

      league_name =  league_name.call( season )   if league_name.is_a?( Proc )  ## is proc/func - name depends on season
      basename    =  basename.call( season )      if basename.is_a?( Proc )  ## is proc/func - name depends on season


      if classic_flag || opts[:classic]
         ## do nothing 
      else 
         ## add quick fix for new league name overwrites
         league_name = LEAGUE_NAMES_V2[league_key] || league_name
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
                     ## add season "inline" (to basename) or use dir
                     ## change base name to league key
                     ##   todo - fix - make gsub smarter
                     ##    change at.cup to at_cup - why? why not?
                     basename = league_key.gsub( '.', '' )
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
