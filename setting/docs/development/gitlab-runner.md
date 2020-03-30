## Run gitlab-runner

```sh
docker run -it --rm gitlab/gitlab-runner --help

docker run -d --name gitlab-runner --restart always \
		   -v /var/run/docker.sock:/var/run/docker.sock \
		   -v /srv/gitlab-runner/config:/etc/gitlab-runner \
		   gitlab/gitlab-runner:latest
```

## Register gitlab-runner

### config file: `/srv/gitlab-runner/config/config.toml`

```sh
docker run -it --rm \
		   -v /srv/gitlab-runner/config:/etc/gitlab-runner \
		   gitlab/gitlab-runner:latest \
		   register
```

## Update Configuration and Logs

```sh
# Update /srv/gitlab-runner/config/config.toml

docker restart gitlab-runner
docker logs gitlab-runner
```

## Upgrage gitlab-runner

```sh
docker pull gitlab/gitlab-runner:latest
docker stop gitlab-runner && docker rm gitlab-runner
```
