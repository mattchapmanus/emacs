# Filename: up.csh
#
# Script to move to another directory above the current directory.
# Requires the following alias to be set (in order to pass the target
# directory into this script):
#
#    alias up 'set UpDir="\!*"; source ~/bin/script/up.csh; unset UpDir'
#
# Usage: up [options] [args]
#
#         up             - move up 1 directory;
#         up <n>         - move up <n> directories;
#         up <dir>       - move up, then down into <dir>
#
# The third form works by moving up one directory at a time looking for
# <dir> at each level.  If the root is reached without finding <dir>,
# we reset to the original directory.
#
# Options:
#         -d             - check for down dir first
#         -p             - pushd instead of cd
#         -q             - do it quietly
#
# Examples:   up
#             up 2
#             up bin
#             up bin/src

set UpOld   = $cwd              # save pointer to current dir
set UpCnt   = 0
set UpQuiet = 0
set UpDown  = 0
set UpPush  = 0
set UpDone  = 0

# echo n = $#UpDir $UpDir

#
# Check for options
#
while ( $#UpDir > 0 )
  set arg = $UpDir[1]
  if ( "$arg" == "-q" ) then
    set UpQuiet = 1
    shift UpDir
  else if ( "$arg" == "-d" ) then
    set UpDown = 1
    shift UpDir
  else if ( "$arg" == "-p" ) then
    set UpPush = 1
    shift UpDir
  else
    break
  endif
end

if ( $UpPush ) then
  set CD = pushd
else
  set CD = cd
endif

if ( $UpDown && "$UpDir" != "" ) then
  if ( -d $UpDir ) then
    $CD "$UpDir"                          # cd down to <dir>
    set UpDone = 1
  endif
endif

if ( ! $UpDone ) then

  if ("$UpDir" == "") then
    set UpCnt=1                           # form is "up"
  else
    foreach UpNum (1 2 3 4 5 6 7 8 9 10)
      if ("$UpDir" == "$UpNum") then
        set UpCnt=$UpNum                  # form is "up <n>"
        break
      endif
    end
    unset UpNum
  endif

  if ($UpCnt != 0) then                   # move up <n> dirs
    while ($UpCnt > 0)
      cd ..
      @ UpCnt -= 1
    end
  else                                    # move up until <dir> is found
    while (1)
      cd ..
      if (-d $UpDir) then
        $CD $UpDir
        break
      else if ("$cwd" == "/") then        # if not found, go back to start dir
        echo $UpDir':' "No such directory"
        cd $UpOld
        break
      endif
    end
  endif
endif

cd .                                      # reset xterm banner

if ( ! $UpQuiet ) echo `pwd`              # display final location

unset UpQuiet
unset UpDown
unset UpOld
unset UpCnt
unset UpPush
