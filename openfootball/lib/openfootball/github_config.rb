
module Openfootball
class GitHubConfig


   ## change Record to RepoRecord or RepoInfo/Config/Entry/Spec etc. - why? why not?
  Record = Struct.new( :owner, :name, :path, :flags,
                         keyword_init: true ) do

     def classic?()   flags ?  flags['classic'] : false; end


     ## change to build_path or path_for or such - why? why not?
     ## suffix e.g.  full (1-bundesliga-full.txt)
     ##
     ##   (opt)classic - true|false - lets you turn on/off classic support - keep - why? why not?
     def mkpath( code:, season:,
                      suffix: nil,
                      classic: true )
        season = Season(season)

        outpath  = "#{owner}/#{name}"
        outpath += "/#{path}"   if path   ## note: do NOT forget to add optional extra path!!!

        basename = if classic? && classic == true
                      league_config = LeagueConfig.find_by!( code: code, season: season )
                      league_config.basename
                   else
                     ## change base name to league key
                     ##   todo - fix - make gsub smarter
                     ##    change at.cup to at_cup - why? why not?
                     code.gsub( '.', '' )
                   end

        basename += "-#{suffix}"   if suffix


        outpath  +=  if classic? && classic == true
                        "/#{season.to_path}/#{basename}.txt"
                     else
                        ## note - add season "inline" (to basename) or use dir
                        "/#{season.to_path}_#{basename}.txt"
                     end
        outpath
     end
  end


  ## map leagues to repo+path
  ##  e.g.   fr.1   => europe/france
  ##         eng..1 => england
  ##
  ##  for other than openfootball (default)
  ## use @
  ##   e.g.    myorg@austria
  ##           austria@myorg ??
  ##
  ##           myorg@europe/france
  ##            europe/france@myorg



def initialize
    @table = {}
end


def add( rows )
  rows.each do |row|
    path = row['path']  ## use pathspec - why? why not?
                        ##  or repospec or such

    ## auto-expand to openfootball as default org if no @ specified
    owner, path = if path.include?( '@' )
                      path.split( '@', 2 )
                  else
                      ['openfootball', path ]
                  end
    ## split on first slash (/)
    ##   note - returns path nil if not slash (/)
    name, path = path.split( '/', 2 )


    ## openfootball@europe/france
    ##    =>
    ##    owner: openfootball
    ##    name:  europe
    ##    path:  france
    ##
    ## openfootball@austria
    ##    =>
    ##    owner: openfootball
    ##    name:  austria
    ##    path:  nil

    rec = Record.new( owner:  owner, ## (required)
                      name:   name,  ## (required)
                      path:   path   ## extra/inner/inside/local path (optional)
                    )

      ## check for/add flags
      ##   note - use to_s to guard for nil (nil.to_s resulting "")
      ## generate/use hash for now
      ##    e.g.   v2 | flat   => { 'v2' => true, 'flat' => true } etc.
      ##     note - [].to_h resulting in {}
      flags = row['flags'].to_s
                 .split( /[ ]*[|][ ]*/ )
                 .map { |flag| [flag, true] }.to_h
      rec.flags = flags      if flags.size > 0


       codes =  row['code'].split( /[ ]*[|][ ]*/ )
       codes.each do |code|
          ## note - make sure/assert key is unique!!!
           raise ArgumentError,
             "duplicate code >#{code}< already in use for >#{row.inspect}<"   if @table.key?( code )

           @table[code] = rec
       end
  end
end



##
## todo/fix:
##   make key lookup more flexible
##    auto-add more variants!!!
##       e.g. at.1  AT1, AT or such
##


## find (full) record by key
def find( q )
  key = q.to_s.downcase

  ## first check for 1:1 match
  rec = @table[key]
  if rec.nil?
     ## try match by (country / first) code
     ##   split by .
     key, _ = key.split( '.', 2 )
     rec = @table[key]
  end

  rec
end
alias_method :[], :find  ## keep alias - why? why not?


end # class GitHubConfig
end # module Openfootball
