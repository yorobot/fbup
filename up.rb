####
# to run use:
#   ruby ./up.rb


$LOAD_PATH.unshift( '../sportdb-writers/lib' )
require 'sportdb/writers'


## same as
## $ fbup -f ./leagues.csv


# args = ['-f', './leagues_fbdat.history.csv' ]
args = ['-f', './leagues_fbdat.csv' ]
# args = ['-f', './leagues.csv' ]
# args <<  '--push'

## args = ['at.1']
Fbgen.main( args )
# Fbup.main( args )

puts "bye"