# Customization Guide

This guide will describe and show usage of many configuration elements for
MC Vagrant. The intended audience is system builders. If you are
looking for a way to make MC Vagrant do more stuff, you are in the right
place.

## Some background on Vagrant/Chef

Vagrant is a scriptable wrapper for Virtualbox and Chef. The **Vagrantfile**
determines the vm and manifest configuration and launches them respectively.

Configuration in vagrant/chef is managed through a combination of cookbooks,
recipes, attributes and roles. For our specific use case roles are not used
and are only mentioned because they may come up in your own documentation
searches.

**recipes**  are the basic *action* wrappers for Chef and are where the atomic
configuration and provisioning happen.

**cookbooks** are collections of related recipes packaged for reuse.

**attributes** are the instance configurable parameters for a particular
recipe. For example, there are attributes to control the memory allocated to
APC. Attributes may be present in the recipe, role and Vagrantfile and are
overridden in that order.

**roles** are collections of recipes and configuration that represent a
responsibility. You may have a "dev web server" role that includes recipes
and default attributes for apache, xhprof and other debugging tools. The
Mediacurrent Vagrant uses recipes to perform this task as recipes may be nested.

## Configuration

The platform is intended to be configured and extended in two primary ways
by the system builder:

1. Editing the Vagrantfile (located in the top-level directory)
2. Creating a project-specific cookbook (under the mc-cookbooks directory)

### Editing the Vagrantfile

To configure the platform by enabling specific recipes, edit the *Vagrantfile*
run list. In most cases, you will only need to uncomment or comment out recipes
already listed in the recipe section of the *Vagrantfile*

        # Enable provisioning with chef solo, specifying a cookbook's path and
        # adding some recipes.
        config.vm.provision :chef_solo do |chef|
          chef.cookbooks_path = [
            'cookbooks/mc-cookbooks',
            'cookbooks/vendor-cookbooks'
          ]

          chef.add_recipe 'lamp'
          chef.add_recipe 'dev-tools'
          #chef.add_recipe 'utils::varnish'
          #chef.add_recipe 'dev-tools::phpmyadmin'
          #chef.add_recipe 'dev-tools::xhprof'
          #chef.add_recipe 'dev-tools::webgrind'
          chef.add_recipe 'drush'
          chef.add_recipe 'default-mcdev'
          #chef.add_recipe 'utils::scripts'
          #chef.add_recipe "utils::solr"

          # You may also specify custom attribute overrides:
          chef.json = {
            #:solr => {
            #  :version => '3.6.2'
            #}
            #:utils => {
            #  :solr => {
            #    :drupal_module_path = "#{mc_settings[:docroot]}/sites/all/modules/apachesolr"
            #  }
            #}
          }.merge(mc_settings)
        end

Details on what each recipe provides are forthcoming and listed in the
*recipes* section of this document.

### Running post install/update changes

One of the very first things that might need to happen is to pull down the db
and files from the dev or testing server. In order to do this ```utils::scripts```
was created. ```utils::scripts``` use a similar concept as git hooks where there
are two different scripts that can be ran ```post-install.sh```, which runs only
once when a new vagrant machine is created and ```post-up.sh```, which runs every
time vagrant provision is ran. A few things to remember is that everytime you
```vagrant destroy``` the current vagrant machine it will re-run the install
script when you run a ```vagrant up```. Whereas, ```post-up.sh``` runs every time
```vagrant up``` or ```vagrant provision``` is ran.
See ```utils::scripts``` [README](../cookbooks/mc-cookbooks/utils/README.md#markdown-header-scripts)
for implmentation notes.

### Creating Project Specific Cookbooks

The system ships with a base project cookbook named *default-mcdev*. This
cookbook performs core setup tasks that should be sufficient in many
use cases.

The following tasks are implemented:

- Installs memcached for system performance.
- Sets up the platform mysql database.
- Creates an apache virtualhost based on template web_app.conf.erb.

*Important Note*: Many projects will run the base project cookbook. Only create
a new project specific cookbook if your project requires additional customization
(running multiple databases, virthosts,
etc.). The custom recipe will have to be maintained by the responsible project team.

Chef cookbooks are written in ruby and consist of attributes, templates,
and recipes. You will notice that there are directories named to match. The
default.rb file is the default execution entry point for a given cookbook.
Beyond that, please refer to other sources better suited for beginning
development with chef.

*Documentation:* Recipies have two built-in documentation files found in the
recipe root: metadata.rb and README.md. Use these files to provide critical
system build data to chef and document the cookbook for maintenance.

- metadata.rb is used to provide chef with system dependencies, version number,
responsible party, licence info, and other system build data.
- README.md is used to provide the long description of the cookbook and additional
instructions and notices.

# Recipes

* dev-tools

    Installs xdebug, rsync, and vim.

    - dev-tools::phpmyadmin
    - dev-tools::webgrind

      **Not compatiable with** ```dev-tools::xhprof```

    - dev-tools::xhprof

      **Not compatiable with** ```dev-tools::webgrind```

* drush

    Installs and configures drush.

* default-mcdev

    The base project-specific cookbook.

* lamp

    A fully functioning LAMP stack.

* utils

    Various utilities.

    - utils::scripts (coming soon)
      Runs a set of scripts ```post-install.sh``` and ```post-up.sh``` from your
      projects docroot.
    - utils::solr
      Installs and configures ApacheSolr, Java, and Jetty.
    - utils::varnish
      Installs and configures Varnish.

**Don't forget to update your mis_vagrant branch and project repo.**
