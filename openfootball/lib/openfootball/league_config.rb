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
        ['leagues'].each do |name|
           recs = read_csv( "#{Openfootball.root}/config/#{name}.csv" )
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


## change/rename to LeaguePeriod or such - why? why not?
Record = Struct.new( :basename,
                     :start_season, :end_season,
                      keyword_init: true ) do
end


def initialize
    @leagues = {}
end


def add( rows )
  rows.each do |row|

    start_season = row['start_season'].to_s
    end_season   = row['end_season'].to_s

    ## note: auto-change seasons to season object or nil
    rec = Record.new( basename:      row['basename'],
                      start_season:  start_season.empty? ? nil : Season.parse( start_season ),
                      end_season:    end_season.empty?   ? nil : Season.parse( end_season ))


    codes =  row['code'].split( /[ ]*[|][ ]*/ )
    codes.each do |code|
       key = self.class.norm( code )
        @leagues[ key ] ||= []
        @leagues[ key ] << rec
    end
  end
end



def find_by( code:, season: )
  raise ArgumentError,
        "league code as string|symbol expected"  unless code.is_a?(String) || code.is_a?(Symbol)

  ## return league code record/item or nil
  ## check for alt code first
  season = Season( season )

  ###  note - was LeagueCodes.norm  (pulls in  leagues gem)
  ##             keep - why? why not?
  ### key    = LeagueCodes.norm( code )
  key = self.class.norm( code )


  recs = @leagues[ key ]

  rec    = nil
  rec =  _find_by_season( recs, season )   if recs
  rec       ## return nil if no code record/item found
end


def _find_by_season( recs, season )
  recs.each do |rec|
      return rec  if (rec.start_season.nil? || rec.start_season <= season) &&
                     (rec.end_season.nil?   || rec.end_season   >= season)
  end
  nil
end


end # class LeagueConfig
end # module Fbup
