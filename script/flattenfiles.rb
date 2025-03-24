############
# to run use:
#    $ ruby script/flattenfiles.rb

require 'cocos'
require 'fifa'


##
## !!! exclude france, netherlands & portugal for now!!!


# rootdir = '/sports/openfootball/europe'
rootdir = '/sports/openfootball/south-america'


paths = Dir.glob( "#{rootdir}/**/*.txt" )

## filter with season in dir

SEASON_DIR = %r{ /
                    \d{4}
                  (-\d{2})?
                 /}x
     
                 

paths = paths.select { |path| SEASON_DIR.match( path ) }



pp paths
puts "   #{paths.size} candiate(s)"

puts "---"

paths.each do |path|
  relpath = path[rootdir.size+1..-1] 

  ## 
  country, season, base = relpath.split( '/' )

  puts "==> #{relpath}"
  print "  "
  pp country, season, base

  ## get country code for country
  cty = Fifa.world.find_by_name( country )
 
=begin
  if cty.nil?
    puts "!! ERROR - no country found for #{country}"
    exit 1
  end

  next if ['france',
           'portugal',
           'netherlands'].include?( country )
=end

  name = nil

  if cty
    puts "#{cty.key} => #{country}"

    name = "#{season}_#{cty.key}"
    if base.start_with?('1')
      name += '1'
    elsif base.start_with?( '2')
      name += '2'
    elsif base.start_with?( 'cup')
      name += 'cup'
    else
      raise ArgumentError, "unexpected basename #{base}"
    end
    name += ".txt"
  else   ## assume internation cup etc.
    name = "#{season}_#{base}"
  end

  puts "  >> #{name} <<"

  oldpath = path
  newpath = "#{rootdir}/#{country}/#{name}"

  puts "  #{path}\n  #{newpath}"

  FileUtils.mv( oldpath, newpath )

end

puts "bye"
