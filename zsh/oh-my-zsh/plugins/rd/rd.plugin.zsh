export RD="/var/www/rd"
export RD_STATION="$RD/rdstation"
export RD_FRONTEND="$RD/rdstation-frontend"

function start_station() {
  cd $RD_STATION
  rd-docker stop
  rd-docker s
}

function start_frontend() {
  REDIS_PORT=$(docker ps -f "name=redis" --format "{{.Ports}}" | awk -F ":" '{print substr($2,0,5)}')
  REDIS_LEGO_EXPORT="redis://0.0.0.0:${REDIS_PORT}"

  cd $RD_FRONTEND
  echo "Redis is running at port: ${REDIS_PORT}"
  export REDISTOGO_URL=$REDIS_LEGO_EXPORT
  echo "Starting ember server"
  ember s
}

#wip
function start_everything() {
  start_station
  start_frontend
}

alias rd-s=start_everything #start everything
alias rd-ss=start_station #start station
alias rd-sf=start_frontend #start frontend
alias rd-c="cd $RD_STATION && rd-docker e web rails c"
alias rd-cc="cd $RD_STATION && rd-docker e web cucumber -t"
alias rd-rc="cd $RD_STATION && rd-docker e web rspec"

