# Syncthing

A terraform module that provisions an AWS EC2 instance, a VPC and its subnet, providing it a public IP address.
THe EC2 instance will run the `.syncthing/user_data.sh` script which will start the syncthing service and make it available on port `8384`.

For more information, example available in [the examples folder](./examples/).

> NB: make sure you have the necessary rights to create the appropriate resources.
