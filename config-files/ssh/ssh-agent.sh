SSH_ENV="$HOME/.ssh/agent_environment"

function start_agent {
    /usr/bin/ssh-agent -s | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
}

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     ps -e | grep ${SSH_AGENT_PID} | grep ssh-agent > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi
	
