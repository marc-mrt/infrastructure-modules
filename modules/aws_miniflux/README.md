# Miniflux

A terraform module that provisions an AWS EC2 instance and runs the [miniflux](https://miniflux.app/) service.
The persistence layer is within the EC2 instance, a volume snapshot is recommended to enable smooth recovery.
