# F5 OpenStack Validation Tools
Tools to validate and test OpenStack cloud with F5 installations

CentOS 7.3 based installation of Tempest for OpenStack Mitaka

Run docker build from the Docker file.

```
  git clone https://github.com/jgruber/f5_openstack_validation_tools.git
  docker build -t f5_openstack_validation_tools ./f5_openstack_validation_tools
```

#### Run an interactive docker container ####

```
  docker run -t -i --name f5_openstack_validation_tools -v [F5_VE_zip_package_dir]:/bigip_images  f5_openstack_validation_tools
```

#### Source a test environment ####
Once your docker container is running you can source a test environment from various init files. You can either download and source your cloud RC file or by sourcing the init files for the environments you will be prompted for your cloud credentials.

  . init-lbaasv2_liberty
  . init-lbaasv2_mitaka
  . init-lbaasv2_newton
  . init-lbassv2_ocata
```

#### Validating your Neutron environment ####

Simply intialize the neutron-valdation environment.

```
  . init-neutron_validate
```

#### Validating your Neutron LBaaSv2 Liberty environment ####

Simply intialize the neutron-valdation environment.

```
  . init-lbaasv2_liberty
```

Once you have initialized the environment you can list and run test using the testr or tempest tools.

```
  testr list-tests
  tempest run --regex '.*smoke'
  testr failing
```

Once your testing is complete you can exit the environment.

```
  deactivate
  cd /
```

#### Validating your Neutron LBaaSv2 Mitaka environment ####

Simply intialize the neutron-valdation environment.

```
  . init-lbaasv2_mitaka
```

Once you have initialized the environment you can list and run test using the testr or tempest tools.

```
  testr list-tests
  tempest run --regex '.*smoke'
  testr failing
```

Once your testing is complete you can exit the environment.

```
  deactivate
  cd /
```

#### Validating your Neutron LBaaSv2 Newton environment ####

The tools are present to validate your Newton cloud, but Newton is not qualified by F5 at this time.


#### Validating your Neutron LBaaSv2 Ocata environment ####

The tools are present to validate your Ocata cloud, but Newton is not qualified by F5 at this time.


#### Importing TMOS Virtual Edition images into your cloud ####

Assure that you can see the desired F5 TMOS zip files in the /bigip_images directory:

```
  ls /bigip_images
```

All F5 TMOS Virtual Edition zip files in that directory will be patched and uploaded to Glance when you source the image importer environment.

```
   . init-image_importer
```

If your LBaaSv2 tests leave residual configuration objects on your BIG-IPs you can clean your environment by adding your BIG-IP credentials to the f5-agent.conf file in your environment and then using the cleaning tool. 

```
  vi ./etc/f5-agent.conf
  ./tools/clean
```

