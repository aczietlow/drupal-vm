# Customization Guide

This guide will describe and show usage of many configuration elements for
MC Vagrant. The intended audience is system builders. If you are
looking for a way to make MC Vagrant do more stuff, you are in the right
place.

## Some background on Vagrant

Vagrant is a scriptable wrapper for Virtualbox. The **config.yml**
determines the vm and manifest configuration and launches them respectively.

Configuration in vagrant is managed through a combination of attributes and roles.

**playbooks**  are the basic *action* wrappers for Ansible and are where the atomic
configuration and provisioning happen.

**roles** are collections packaged for reuse.

## Configuration

The platform is intended to be configured and extended in two primary ways
by the system builder:

1. Editing the config.yml (located in the top-level directory)
2. Creating a project-specific role (under the provisioning/roles directory) ( TBD)

### Editing config.yml

To configure the platform by enabling specific features, edit the *config.yml*
file. In most cases, you will only need to uncomment or comment out variables.

        

### Running post install/update changes

(TBD)

### Creating Project Specific Actions

(TBD)
