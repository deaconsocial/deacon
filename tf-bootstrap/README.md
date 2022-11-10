# Bootstrap

This module sets up the S3 backend for storing Terraform state. Since we are running on DigitalOcean, the state is actually being stored in DO Spaces using the S3-compatible API.

After the initial setup using the default local backend, we re-initialized this module using the new state backend so that the remote state contains state for this module itself.
