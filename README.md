# Base host management formula

## Description
This formula provides basic utilities and tools configuration, including packages installation, editor configuration, etc.
```yaml
base:
  packages:
    custom:
      - 'some_package_name'
  sysctl:
    vm.swappiness: '1'
    net.ipv4.tcp_syncookies: '1'
    net.ipv4.tcp_fin_timeout: '60'
    net.ipv4.conf.all.rp_filter: '1'
    net.ipv4.conf.all.log_martians: '1'
    net.ipv4.conf.all.secure_redirects: '0'
    net.ipv4.conf.all.accept_source_route: '0'
    net.ipv4.icmp_echo_ignore_broadcasts: '1'
  shell:
    timeout: '600'
  aliases:
    commands:
      mc: "alias mc='EDITOR=vi VIEWER=less mc'"
```
For additional available configuration parameters please follow reference in pillar.example.

## Testing
Tests use kitchen-salt, serverspec and docker.
Before starting please ensure you are running **docker-ce** and having **kitchen** tools installed.

#### For using with kitchen first you have to:
```shell script
gem install \
  test-kitchen \
  kitchen-salt \
  kitchen-docker
```

#### Be aware:
Before deploying container with systemd based operation systems, you should add to `.kitchen.yml`
driver option `run_command: /sbin/init` to load systemd as the first container
process (`/sbin/init` commonly is a symbolic link to `/lib/systemd/systemd`),
otherwise you will not able to invoke systemctl command.
Additionally, you need to define specific capabilities and cgroup volume at docker driver section:
```yaml
driver:
  name: 'docker'
  volume: '/sys/fs/cgroup:/sys/fs/cgroup:ro'
  cap_add:
    - 'SYS_ADMIN'
```

##### Deploy an instance and runs the  main state:
`kitchen converge $PLATFORM`
##### Run Serverspec tests:
`kitchen verify $PLATFORM`
##### Destroy, create, converge and run test from scratch onto the prepared instance:
`kitchen test $PLATFORM`
