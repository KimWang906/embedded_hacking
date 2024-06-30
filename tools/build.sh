DOCKER_CONTAINER_NAME="tools"
DOCKER_IMAGE_NAME="build_tools"

# Build the strace and ltrace tools
docker build -t ${DOCKER_IMAGE_NAME}:latest docker
docker run --name ${DOCKER_CONTAINER_NAME} -d -t ${DOCKER_IMAGE_NAME}:latest

docker cp ${DOCKER_CONTAINER_NAME}:/root/strace build/
docker cp ${DOCKER_CONTAINER_NAME}:/root/ltrace build/
docker cp ${DOCKER_CONTAINER_NAME}:/root/gdb build/
docker cp ${DOCKER_CONTAINER_NAME}:/root/gdbserver build/

# docker rm -f ${DOCKER_CONTAINER_NAME}
