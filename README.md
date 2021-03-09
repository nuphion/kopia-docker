# kopia-docker

> [Kopia](https://github.com/kopia/kopia) is a simple, cross-platform tool for managing encrypted backups in the cloud. It provides fast, incremental backups, secure, client-side end-to-end encryption, compression and data deduplication.

[rclone](https://github.com/rclone/rclone) is installed in the container for use as a Kopia storage backend.

## Usage

The docker expects a file named kopia_cron to exist in container path /config

On startup, cron schedules from this file are activated within the container.

Example cron to print the current Kopia version to the docker log at 3am every day:
```
0 3 * * * kopia --version
```

Startup commands, such as to connect to a Kopia repository on container start, can be specified with `@reboot`:
```
@reboot kopia repository connect --p password123
```

The above is provided for example purposes only, you might choose to pass the repository password to Kopia differently.

**Parameters**
* `-v /config` The path to the kopia_cron file
* `-v /data` The path to the repository that Kopia will be working with
