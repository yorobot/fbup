############
# to run use:
#    $ ruby up/fbdat_summary.rb


require_relative 'helper'


require 'sportdb/linters'    # e.g. uses TeamSummary class



DATAFILES_DIR = Footballdata.config.convert.out_dir


team_buf, team_errors   = SportDb::TeamSummary.build( DATAFILES_DIR )

path = "#{DATAFILES_DIR}/SUMMARY.md"
write_text( path, team_buf )


puts "#{team_errors.size} error(s) - teams:"
pp team_errors

puts 'bye'

