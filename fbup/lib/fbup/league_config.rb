module Fbup

####
### check - rename to ExtraLeagueConfig or such - why? why not?

class LeagueConfig 
    
def self.find_by( code:, season: )
    ## return league code record/item or nil
    builtin.find_by( code: code, season: season )
end


#####
## (static) helpers
def self.builtin
   ## get builtin league code index (build on demand)
   @leagues ||= begin
        leagues = LeagueConfig.new
        ['leagues',
        ].each do |name|
           recs = read_csv( "#{SportDb::Module::Fbup.root}/config/#{name}.csv" )
           leagues.add( recs )
        end
        leagues
   end
   @leagues
end


def self.norm( code )      ## use norm_(league)code - why? why not?
  ## norm league code
  ##   downcase
  ##   and remove all non-letters/digits e.g. at.1 => at1, at 1 => at1 etc.
  ##                                            ö.1 => ö1
  ##   note - allow unicode letters!!! 
  ##    note - assume downcase works for unicode too e.g. Ö=>ö
  ##           for now no need to use our own downcase - why? why not?

  code.downcase.gsub( /[^\p{Ll}0-9]/, '' )
end




def initialize
    @leagues = {}
end    


def add( recs )
  recs.each do |rec|
    key = LeagueConfig.norm( rec['code'] )
    @leagues[ key ] ||= []

    ## note: auto-change seasons to season object or nil
    @leagues[ key ] << {  'code'         => rec['code'],
                          'basename'     => rec['basename'],
                          'start_season' => rec['start_season'].empty? ? nil : Season.parse( rec['start_season'] ),
                          'end_season'   => rec['end_season'].empty?   ? nil : Season.parse( rec['end_season'] ),
                       }
  end
end


def find_by( code:, season: )
  raise ArgumentError, "league code as string|symbol expected"  unless code.is_a?(String) || code.is_a?(Symbol)

  ## return league code record/item or nil
  ## check for alt code first
  season = Season( season )
  key    = LeagueCodes.norm( code )
  rec    = nil

  recs = @leagues[ key ] 

  if recs
    rec =  _find_by_season( recs, season )
  end

  rec   ## return nil if no code record/item found
end


def _find_by_season( recs, season )
  recs.each do |rec|
      start_season = rec['start_season']
      end_season   = rec['end_season']
      return rec  if (start_season.nil? || start_season <= season) &&
                     (end_season.nil? || end_season >= season)
  end
  nil
end


end # class LeagueConfig


end # module Fbup
