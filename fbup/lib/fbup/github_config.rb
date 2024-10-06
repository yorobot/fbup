
module Fbup
class GitHubConfig

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
    recs = read_csv( path )
    new( recs )
end

def initialize( recs=nil )
    @table = {}
    add( recs )  if recs
end


def add( recs )
  recs.each do |rec|
    path = rec['path']  ## use pathspec - why? why not?
                        ##  or repospec or such

    ## auto-expand to openfootball as default org if no @ specified
    owner, path = if path.index( '@')
                      path.split( '@', 2 )
                  else
                      ['openfootball', path ]
                  end
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
    @table[ rec['key'] ] = {  'owner' => owner, ## (required)
                              'name'  => name,  ## (required)
                              'path'  => path   ## extra/inner/inside/local path (optional)
                            }
  end
end


##
## todo/fix:
##   make key lookup more flexible
##    auto-add more variants!!!
##       e.g. at.1  AT1, AT or such
##

## find (full) record by key
def find( key )
  key = key.to_s.downcase

  ## first check for 1:1 match
  rec = @table[key]
  if rec.nil?
     ## try match by (country / first) code
     ##   split by .
     key, _ = key.split( '.' )
     rec = @table[key]
  end

  rec
end
alias_method :[], :find  ## keep alias - why? why not?


def find_repo( key )
   rec = _find( key )

   rec ? "#{rec['owner']}/#{rec['name']}" : nil
end

end # class GitHubConfig
end # module Fbup



