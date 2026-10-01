##########
# to run use:
#   $ ruby sandbox/read_github.rb

require 'cocos'


require_relative '../lib/openfootball/github_config'



repos = Fbup::GitHubConfig.new
repos.add( read_csv( './config/openfootball.csv' ))
repos.add( read_csv( './config/openfootball-europe.csv' ))
pp repos


pp repos['at.1']
pp repos['at.3.o']
pp repos['at.cup']

pp repos['eng.3']
pp repos['eng.5']

pp repos['fr.1']
pp repos['fr.cup']

puts "bye"