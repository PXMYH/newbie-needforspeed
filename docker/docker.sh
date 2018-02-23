# check image laters
docker images --tree # old
docker history <image_id>

# or 
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images -t
