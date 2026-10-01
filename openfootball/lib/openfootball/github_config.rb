
module Fbup
class GitHubConfig


  ##
  ##  fix-fix-fix
  ##    add classic?
  ##         and such methods!!!

  Record = Struct.new( :owner, :name, :path, :flags,
                         keyword_init: true ) do
     def classic?
        ## to be done
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


def self.read( path )
    rows = read_csv( path )
    new( rows )
end

def initialize( rows=nil )
    @table = {}
    add( rows )  if rows
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
      flags = row['flags'].split( /[ ]*[|][ ]*/ )
      ## generate/use hash for now
      ##    e.g.   v2 | flat   => { 'v2' => true, 'flat' => true } etc.
      flags = flags.map { |flag| [flag, true] }.to_h
      rec.flags = flags      if flags.size > 0

      ## todo/fix - make sure/assert key is unique!!!
    @table[ row['code'] ] = rec
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



def find_repo( q )
   rec = _find( q )

   rec ? "#{rec.owner}/#{rec.name}" : nil
end

end # class GitHubConfig
end # module Fbup
