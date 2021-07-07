[![license](https://img.shields.io/github/license/nuphion/kopia-docker)](https://github.com/nuphion/kopia-docker/blob/main/LICENSE) [![docker build](https://img.shields.io/docker/cloud/build/nuphion/kopia)](https://hub.docker.com/r/nuphion/kopia) [![docker image size](https://img.shields.io/docker/image-size/nuphion/kopia/latest)](https://hub.docker.com/r/nuphion/kopia)

# kopia-docker

> [Kopia](https://github.com/kopia/kopia) is a simple, cross-platform tool for managing encrypted backups in the cloud. It provides fast, incremental backups, secure, client-side end-to-end encryption, compression and data deduplication.

[rclone](https://github.com/rclone/rclone) is installed in the container for use as a Kopia storage backend.

This docker image is in __beta__. It Works On My Machine&trade;, but not every Kopia feature has been tested.

## Usage

The docker expects a file named `kopia_cron` to exist in container path /config

On startup, cron schedules from this file are activated within the container.

Example cron to print the current Kopia version to the docker log at 3am every day:
```
0 3 * * * kopia --version
```

In practice, you may want to write a short script:
```
0 3 * * * sh /config/kopia.sh
```

With example contents:
```
#!/usr/bin/with-contenv sh

PASS=$(your_secure_method_to_get_password)
kopia repository connect rclone --remote-path myremote: --rclone-exe /usr/bin/rclone -p ${PASS}
kopia snapshot create /data
kopia repository disconnect
```

**Parameters**
* `-v /config` The path to the kopia_cron file
* `-v /data` The path to the data that Kopia will be backing up
* `--hostname foo` Kopia works better when given a static hostname that will persist through container updates

Example:
`docker run 'nuphion/kopia:latest' -d --name 'kopia' -v '~/docker/appdata/kopia/':'/config':'rw' -v '/some/path/to/files/':'/data':'ro' --hostname 'foo'`

## Roadmap

- Multi-architecture builds (currently only linux/amd64 available)