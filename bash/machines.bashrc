# Configuration specific to machines / networks

# Local configuration
if [[ "${HOSTNAME}" == "kogitox"* ]]; then
	:  # Does nothing

# Gerad configuration
elif [[ "${HOSTNAME}" == *".gerad.lan" ]]; then
	source /home/modules/Bashrc
	module load tmux
	module load gcc/7.2.0
	module load git
	module load htop
	module load singularity/3.1.1

	# Local disk space
	if [ -d "/local_workspace" ]; then
		export SCRATCH="/local_workspace/${USER}"
	elif [ -d "/local1" ]; then
		export SCRATCH="/local1/${USER}"
	fi

	# Virt env locations
	export WORKON_HOME="${SCRATCH}/venvs"

# Mila cluster configuration
elif [[ "${HOSTNAME}" == *"server.mila.quebec" ]]; then
	module load singularity/3

	# Network space
	export SCRATCH="/network/tmp1/${USER}"

# Compute Canda configuration
elif [[ "${HOSTNAME}" == *"calculquebec.ca" ]]; then
	module load python/3.7
	module load singularity/3.2

fi
