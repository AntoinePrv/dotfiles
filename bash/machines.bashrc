# Configuration specific to machines / networks

# Local configuration
if [ "${HOSTNAME}" = "kogitox.local" ]; then
	:  # Does nothing

# Gerad configuration
elif [ "$(hostname -d)" = "gerad.lan" ]; then
	# Load some module
	source /home/modules/Bashrc
	module load tmux
	module load gcc/7.2.0
	module load git
	module load htop
	module load singularity

	# Local disk space
	if [ -d "/local_workspace" ]; then
		LOCAL_WORKSPACE="/local_workspace/proant"
	elif [ -d "/local1" ]; then
		LOCAL_WORKSPACE="/local1/proant"
	fi

	# Virt env locations
	export WORKON_HOME="${LOCAL_WORKSPACE}/venvs"
fi
