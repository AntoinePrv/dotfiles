# Configuration specific to machines / networks

# Default values
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export WORKSPACE_DIR="${HOME}/workslace"


# Local configuration
if [[ "${HOSTNAME}" == "kogitox"* ]]; then
	# For CMake to poperly find package
	export SDKROOT=$(xcodebuild -version -sdk macosx Path)

# Gerad login node
elif [[ "${HOSTNAME}" == "nexus2.gerad.lan" ]]; then
	return  # Do nothing

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
		WORKPLACE_DIR="/local_workspace/${USER}"
	elif [ -d "/local1" ]; then
		WORKPLACE_DIR="/local1/${USER}"
	fi
	export XDG_CACHE_HOME="${WORKPLACE_DIR}/cache"
	export XDG_DATA_HOME="${WORKPLACE_DIR}/local/share"
	export SCRATCH_DIR="/tmp/scratch"

# Mila cluster configuration
elif [[ "${HOSTNAME}" == *"server.mila.quebec" ]]; then
	module load singularity/3.2.0

	# Local disk space
	export XDG_CACHE_HOME="/network/tmp1/${USER}/cache"
	export XDG_DATA_HOME="/network/tmp1/${USER}/local/share"
	export SCRATCH_DIR="${SLURM_TMPDIR-/tmp}/scratch"

# Compute Canda configuration
elif [[ "${HOSTNAME}" == *"calculquebec.ca" ]]; then
	module load python/3.7
	module load singularity/3.2

	# Local disk space
	export XDG_CACHE_HOME="/network/tmp1/${USER}/cache"
	export XDG_DATA_HOME="/network/tmp1/${USER}/local/share"
	export SCRATCH_DIR="${SLURM_TMPDIR-/tmp}/scratch"

fi

mkdir -p "${XDG_CONFIG_HOME}" "${XDG_CACHE_HOME}" "${XDG_DATA_HOME}" "${WORKSPACE_DIR}"
[ ! -z ${SCRATCH_DIR+x} ] &&  mkdir -p "$SCRATCH_DIR"
