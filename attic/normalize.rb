########
# helper
#   normalize team names

###    fix !!!!!   - always add season:  (for generic interface/api)
##      e.g. def normalize( matches, league:, season: )


  def normalize( matches, league:, season: )
    matches = matches.sort do |l,r|
      ## first by date (older first)
      ## next by matchday (lowwer first)

     ## todo/fix
     ##    if no time  (assume 0:00 for now)

      res =   l.date <=> r.date
      res =   (l.time ? l.time : '0:00') <=> (r.time ? r.time : '0:00')    if res == 0
      res =   l.round <=> r.round   if res == 0
      res
    end


    league = League.find!( league )
 
    stats = {}

    ## todo/fix: cache name lookups - why? why not?
    puts "   normalize #{matches.size} matches..."
    matches.each_with_index do |match,i|        
       team1 = Club.find_by!( name:   match.team1,
                              league: league )
       team2 = Club.find_by!( name:   match.team2,
                              league: league )

       if match.team1 != team1.name
          stat = stats[ match.team1 ] ||= Hash.new(0)
          stat[ team1.name ] += 1
       end   

       if match.team2 != team2.name
          stat = stats[ match.team2 ] ||= Hash.new(0)
          stat[ team2.name ] += 1
       end
   
       match.update( team1: team1.name )
       match.update( team2: team2.name )
    end
   
    if stats.size > 0
      pp stats
    end

    print "norm OK\n"

    matches
  end

