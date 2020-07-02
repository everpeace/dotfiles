export GHQ_ROOT=$HOME/src

# gh(e)i: ghs + peco + ghq import utilities
function ghi(){
  [ "$#" -eq 0 ] && echo "Usage : gpi QUERY" && return 1
  ghs "$@" | peco | awk '{print $1}' | ghq import -p
}

function ghqcd(){
  # [ "$#" -eq 0 ] && echo "Usage : ghqcd QUERY" && return 1
  local full_path
  full_path=$(ghq list -p -e "$(ghq list "$@" | peco | awk '{print $1}')")
  cd "$full_path"
}
