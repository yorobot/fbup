
module Fbup   ### rename module to Up - why? why not?

###
## todo/fix:
##   add -i/--interactive flag
##     will prompt yes/no  before git operations (with consequences)!!!



class GitHubSync

########
##  (auto)default to Writer.config.out_dir - why? why not?
##
##    note - is monotree (that is, requires openfootball/england etc.
##                  for repo pathspecs)
def self.root()  @root || "/sports"; end
def self.root=( dir ) @root = dir; end
## use root_dir (or add alias) - why? why not?


REPOS = GitHubConfig.new
recs = read_csv( "#{SportDb::Module::Fbup.root}/config/openfootball.csv" )
REPOS.add( recs )

## note: datasets of format
##
## DATASETS = [
##   ['it.1',    %w[2020/21 2019/20]],
##  ['it.2',    %w[2019/20]],
##  ['es.1',    %w[2019/20]],
##  ['es.2',    %w[2019/20]],
## ]

def self.find_repos( datasets )
repos = []
datasets.each do |league_key, seasons|
  repo  = REPOS[ league_key ]
  ## pp repo
  if repo.nil?
     puts "!! ERROR - no repo config/path found for league >#{league_key}<; sorry"
     exit 1
  end

  repos <<  "#{repo['owner']}/#{repo['name']}"
end

pp repos
repos.uniq   ## note: remove duplicates (e.g. europe or world or such)
end



def initialize( repos )
    @repos = repos
end


def git_push_if_changes
   message = "auto-update week #{Date.today.cweek}"  ## add /#{Date.today.cday - why? why not?
   puts message

   @repos.each do |pathspec|
       _git_push_if_changes( pathspec, message: message )
   end
end

def git_fast_forward_if_clean
    @repos.each do |pathspec|
      _git_fast_forward_if_clean( pathspec )
    end
end



## todo/fix: rename to something like
##    git_(auto_)commit_and_push_if_changes/if_dirty()

def _git_push_if_changes( pathspec, message: )
    path = "#{self.class.root}/#{pathspec}"

    Gitti::GitProject.open( path ) do |proj|
      puts ''
      puts "###########################################"
      puts "## trying to commit & push repo in path >#{path}<"
      puts "Dir.getwd: #{Dir.getwd}"
      output = proj.changes
      if output.empty?
        puts "no changes found; skipping commit & push"
      else
        proj.add( '.' )
        proj.commit( message )
        proj.push
      end
    end
end


def _git_fast_forward_if_clean( pathspec )
    path = "#{self.class.root}/#{pathspec}"

    Gitti::GitProject.open( path ) do |proj|
      output = proj.changes
      unless  output.empty?
        puts "FAIL - cannot git pull (fast-forward) - working tree has changes:"
        puts output
        exit 1
      end

      proj.fast_forward
    end
end
end  # class GitHub
end  # module Fbup
