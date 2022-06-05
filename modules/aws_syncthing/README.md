# Syncthing

A terraform module that provisions an AWS EC2 instance, a VPC and its subnet, providing it a public IP address.
THe EC2 instance will run the `.syncthing/user_data.sh` script which will start the syncthing service and make it available on port `8384`.

For more information, example available in [the examples folder](./examples/).

> NB: make sure you have the necessary rights to create the appropriate resources.

## Variables:

Make sure to populate the `instance_parameters` variable with the required values, for example:

```json
[
  {
    "name": "syncthing/gui/username",
    "value": "admin"
  },
  {
    "name": "syncthing/gui/password",
    "value": "test"
  },
  {
    "name": "syncthing/device/name",
    "value": "AWS EC2"
  },
  {
    "name": "syncthing/defaults/folder/path",
    "value": "/var/syncthing/"
  }
]
```
