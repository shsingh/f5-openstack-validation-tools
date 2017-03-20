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

Once your docker container is running you can source a test environment from various init files. Each test environment has a initialization script which will query your cloud for required testing configuration. 

You can download yor cloud RC file to your container and source the environment

```
   . overcloudrc
```
or the initialization script will prompt for your cloud credentials.

```
  OpenStack Tenant: admin
  OpenStack Username: admin
  OpenStack Password:
  OpenStack Auth URL: http://controller:5000/v2.0
```

#### Validating your Neutron environment for use with F5 Multi-Tenant Services####

Simply intialize the neutron-valdation environment.

```
  . init-neutron_validate
```

To exit your test environment simply run:

```
  finished
```





#### Validating your Liberty Neutron environment ####

Simply intialize the neutron-valdation environment.

```
  . init-neutron_liberty
```

Once you have initialized the environment you run the validation tests simply run: 

```
  ./run_tests.sh
```

Alternatively you can list and run test using the ```testr``` or ```tempest``` community tools.

```
  testr list-tests
  tempest run --regex '.*smoke'
  testr failing
```

To exit your test environment simply run:

```
  finished
```


#### Validating your Liberty Neutron LBaaSv2 environment ####

Once your LBaaSv2 environment is setup you can test the validity of your environment.

Simply intialize the LBaaSv2 valdation environment.

```
  . init-lbaasv2_liberty
```

Once you have initialized the environment you run the validation tests simply run: 

```
  ./run_tests.sh
```

Alternatively you can list and run test using the ```testr``` or ```tempest``` community tools.

```
  testr list-tests
  tempest run --regex '.*smoke'
  testr failing
```

To exit your test environment simply run:

```
  finished
```






#### Validating your Mitaka Neutron environment ####

Simply intialize the neutron-valdation environment.

```
  . init-neutron_mitaka
```

Once you have initialized the environment you run the validation tests simply run: 

```
  ./run_tests.sh
```

Alternatively you can list and run test using the ```testr``` or ```tempest``` community tools.

```
  testr list-tests
  tempest run --regex '.*smoke'
  testr failing
```

To exit your test environment simply run:

```
  finished
```


#### Validating your Mitaka Neutron LBaaSv2 environment ####

Once your LBaaSv2 environment is setup you can test the validity of your environment.

Simply intialize the LBaaSv2 valdation environment.

```
  . init-lbaasv2_mitaka
```

Once you have initialized the environment you run the validation tests simply run: 

```
  ./run_tests.sh
```

Alternatively you can list and run test using the ```testr``` or ```tempest``` community tools.

```
  testr list-tests
  tempest run --regex '.*smoke'
  testr failing
```

To exit your test environment simply run:

```
  finished
```




#### Importing TMOS Virtual Edition images into your cloud ####

Assure that you can see the desired F5 TMOS zip files in the /bigip_images directory:

```
  ls /bigip_images
```

All F5 TMOS Virtual Edition zip files in that directory will be patched and uploaded to Glance when you source the image importer environment.

```
   . init-image_importer
```

#### Cleaning your environemnt after failed tests ####

If your tests leave residual configuration objects on your BIG-IPs you can clean your environment using the cleaning tool. From within the environment you can issue the following command:

```
  ./tools/clean
```
