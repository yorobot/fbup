
require 'sportdb/writers'


require 'optparse'    ## command-line processing; check if included updstream?

########################
#  push & pull github scripts
require 'gitti'    ## note - requires git machinery



###
# our own code
require_relative 'fbup/version'

require_relative 'fbup/github_config'
require_relative 'fbup/github'   ## github helpers/update machinery


require_relative 'fbup/main'





puts SportDb::Module::Fbup.banner   # say hello
