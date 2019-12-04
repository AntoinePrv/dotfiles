# Configuration specific to machines / networks

# Local configuration
if [[ "${HOSTNAME}" == "kogitox"* ]]; then
	# Local disk space
	export CACHE_DIR="${HOME}/.cache"
	export WORKSPACE_DIR="${HOME}/workspace"
	export SCRATCH_DIR="/tmp/scratch"

# Gerad configuration
elif [[ "${HOSTNAME}" == *".gerad.lan" ]]; then
	source /home/modules/Bashrc
	module load tmux
	module load gcc
	module load cmake
	module load git
	module load htop
	module load singularity
	module load anaconda

	# Local disk space
	if [ -d "/local_workspace" ]; then
		LOCAL_DIR="/local_workspace/${USER}"
	elif [ -d "/local1" ]; then
		LOCAL_DIR="/local1/${USER}"
	fi
	export CACHE_DIR="${LOCAL_DIR}/cache"
	export WORKSPACE_DIR="${LOCAL_DIR}/workspace"
	export SCRATCH_DIR="/tmp/scratch"

# Mila cluster configuration
elif [[ "${HOSTNAME}" == *"server.mila.quebec" ]]; then
	module load singularity/3.2.0

	# Local disk space
	export CACHE_DIR="/network/tmp1/${USER}/cache"
	export WORKSPACE_DIR="/network/tmp1/${USER}/workspace"
	export SCRATCH_DIR="${SLURM_TMPDIR-/tmp}/scratch"

# Compute Canda configuration
elif [[ "${HOSTNAME}" == *"calculquebec.ca" ]]; then
	module load python/3.7
	module load singularity/3.2

	# Local disk space
	export CACHE_DIR="/network/tmp1/${USER}/cache"
	export WORKSPACE_DIR="/network/tmp1/${USER}/workspace"
	export SCRATCH_DIR="${SLURM_TMPDIR-/tmp}/scratch"

fi

mkdir -p "$CACHE_DIR" "$WORKSPACE_DIR" "$SCRATCH_DIR"
