# Admin Quickstart Guide

## Introduction

The vagrant build is designed to be added to an existing project and may sit
alongside or live within the project repository (as a git submodule). Which
method makes the most sense depends on project needs and architecture.

It is expected that you have installed and tested out the MIS Example project
build prior to attempting to set up a vagrant build for your own project. This
will provide you with a working vagrant environment and knowledge of what will
need to be provided to other team members.

The example client project branch is found on bitbucket

    git clone git@bitbucket.org:mediacurrent/mis_example.git
    git checkout develop

This example project is configured with a submodule to track the
projects/mc-mis_example branch on the vagrant side and is used to test and train
internally. This Vagrant project's branch is built off master like any other
Vagrant projects branch should be.

## Installation

Follow all instructions in the [User Quickstart](UserQuickstart.md) to ensure
that you have all required dependencies.

1. Create (or clone locally) your client project repo. This will be referred to
as [myrepo] for the remainder of this document.

2. Once your client project repo is created, you have two options:
    * Make mis_vagrant a submodule of your project's repo (As long as the
      docroot is not the root of your repo).
      ```[myrepo]$ git submodule add git@bitbucket.org:mediacurrent/mis_vagrant.git```
    * Clone the mis_vagrant project into a directory parallel to your repo.
      ```[myrepo]$ cd .. && git clone git clone git@bitbucket.org:mediacurrent/mis_vagrant.git```

3. Change into the mis_vagrant repo, switch to the master branch, and
create a new projects branch. **Important:** all projects branches must be
branched from master for maintainability. The project branch is where changes
specific to your project are kept and maintained over time. Remember to replace
"client" and "project" with names that are appropriate for your project. Your
project's vagrant branch will be referred to as [vagrant_repo] throughout this
document.

        [vagrant_repo]$ git checkout master
        [vagrant_repo]$ git checkout -b projects/client--project

4. Modify the Vagrantfile to match the desired server configuration
(more detail below).

5. Modify the Vagrantfile mc_settings to specify the local domain and
host_docroot for your project relative to the Vagrantfile.

        mc_settings = {
          :domain       => 'example.mcdev',
          :docroot      => '/home/vagrant/docroot',
          :host_docroot => '../docroot',
          :database_name => 'example_mcdev'
        }

    * :docroot: The path to the apache docroot on the guest virtual machine
    (running inside virtualBox) and should not be changed unless you really
    know what you are doing.
    * :host_docroot: The location of the project docroot relative to
    this file on the host machine.

6. Add the domain/IP for this installation to the [Vagrant IP address allocation](https://docs.google.com/a/mediacurrent.com/spreadsheet/ccc?key=0AuLhQk3Txl-JdFNGOGNEV0twcUlwR09tWkU1NVNMZnc&usp=sharing).
spreadsheet. Specify the next IP in the current range and add to the proper
column in the spreadsheet. Use this IP/domain combination in the following steps.
The /etc/hosts entry will be populated for you by the spreadsheet. If you do
not have access to edit this spreadsheet, a member of DevOps will help you.
You will get something like the following from the "All hosts" column.

        #Vagrant Hosts Entries
        192.168.50.4 example.mcdev

    Instructions have been provided in the user quickstart guide to add an entry
    to their /etc/hosts file that matches this. Please provide this to your team
    members after setup.

7. Modify the line in the Vagrantfile with the IP generated in step 6.

        # Create a private network, which allows host-only access to the machine
        # using a specific IP.
        config.vm.network :private_network, ip: "192.168.50.4"

8. Create or add to existing drushrc file within your project repository
(not the vagrant branch you just created)
docroot/sites/all/drush/[project shortname].aliases.drushrc.php with the
following.

        // Vagrant local development vm.
        $aliases['mcdev'] = array(
          'uri' => 'example.mcdev',
          'root' => '/home/vagrant/docroot',
          'remote-host' => 'example.mcdev',
          'path-aliases' => array(
            '%drush-script' => '/usr/local/bin/drush',
          ),
          'remote-user' => 'vagrant',
        );

9. Check in your vagrant configuration and push to a project specific *projects/client--project*
branch.

        [vagrant_repo]$ git commit -a -m 'creating branch for project name'
        [vagrant_repo]$ git push origin projects/client--project

10. (Only necessary if you chose to use a submodule) Add the mis_vagrant
directory and check in your projects' repo. This will need to be done anytime
a change is made to mis_vagrant as the submodule keeps track of a sha hash
that the submodule should be pointing to.

        [myrepo]$ git submodule add mis_vagrant
        [myrepo]$ git push origin branchspec

11. *Note:* Additional configuration is possible and explained in the [Customization
guide](Customization.md). The two areas of intended configuration are by editing the *Vagrantfile* and
through the creation of project-specific cookbooks.

## Troubleshooting