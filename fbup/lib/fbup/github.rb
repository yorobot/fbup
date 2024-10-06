
module Fbup

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
## use root_dir (alias) - why? why not?


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
