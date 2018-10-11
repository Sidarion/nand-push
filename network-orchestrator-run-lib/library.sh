# library for prod-run, sim-run etc.

set_up_mutex() {
  local scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"
  mutex_set_by_us=false
  mutex="${scriptpath}/.run.mutex"
  
  if [ ! -x "/usr/bin/lockfile" ]; then
    echo "ERROR: we need the lockfile binary, availably in RedHat in the procmail package" >&2
    exit 1
  fi

  # remove mutex on exit, interrupt etc.
  trap 'mutex_unlock; exit' EXIT INT TERM HUP
}
set_up_mutex

mutex_unlock() {
  if [ "$mutex_set_by_us" == "true" ]; then
    rm "$mutex"
  fi
}

# mutex_lock "PRODUCTION"
#
mutex_lock() {
  local run_type="$1"
  while ! lockfile -1 -r 0 "$mutex" 2>/dev/null; do
    echo "Someone is already running a $( cat $mutex ) run. Waiting..."
    sleep 5
  done
  mutex_set_by_us=true

  echo "$run_type" > "$mutex"
}

# starting_network_automation PRODUCTION
#
starting_network_automation() {
  echo
  echo "Starting network automation ${1}"
  echo "######################################"
  echo 

  mutex_lock "${1}"
}
