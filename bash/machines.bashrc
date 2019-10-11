# Configuration specific to machines / networks

# Local configuration
if [[ "${HOSTNAME}" == "kogitox"* ]]; then
	:  # Does nothing

# Gerad configuration
elif [[ "${HOSTNAME}" == *".gerad.lan" ]]; then
	source /home/modules/Bashrc
	module load tmux
	module load gcc
	module load cmake
	module load git
	module load htop
	module load singularity

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
	module load singularity/3.2.0
	export SCRATCH="/network/tmp1/${USER}"
	export WORKON_HOME="${SLURM_TMPDIR-$SCRATCH}/venvs"
	mkdir -p $WORKON_HOME

# Compute Canda configuration
elif [[ "${HOSTNAME}" == *"calculquebec.ca" ]]; then
	module load python/3.7
	module load singularity/3.2

fi
