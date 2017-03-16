#!/bin/bash

DIR=/lbaasv2_liberty

# Get correct version of the software to test and
# copy to the working directory for the environemnt
mkdir $DIR/build

# liberty-eol version of neutron-lbaas
cd $DIR/build
git clone https://github.com/openstack/neutron.git
cd $DIR/build/neutron
git fetch --all
git checkout -b liberty liberty-eol
mv $DIR/build/neutron $DIR/neutron

# dependancies on liberty-eol neutron
cd $DIR/build
git clone https://github.com/openstack/neutron-lbaas.git
cd $DIR/build/neutron-lbaas
git fetch --all
git checkout -b liberty liberty-eol
mv $DIR/build/neutron-lbaas/neutron_lbaas $DIR/
mv $DIR/build/neutron-lbaas/requirements.txt $DIR/neutron_lbaas/requirements.txt
mv $DIR/build/neutron-lbaas/test-requirements.txt $DIR/neutron_lbaas/test-requirements.txt

# get rid of the unused source and branches
rm -rf $DIR/build

# install in the virtualenv for the environment
cd $DIR
/bin/bash -c "cd $DIR \
              && source ./bin/activate \
              && pip install -r ./neutron_lbaas/requirements.txt \
              && pip install -r ./neutron_lbaas/test-requirements.txt \
              && mkdir $DIR/tempest_lib \
              && cp -Rf $DIR/lib/python2.7/site-packages/tempest_lib/* $DIR/tempest_lib/ \
              && pip install --upgrade eventlet tempest f5-openstack-agent pyopenssl junitxml"

# patch files
find $DIR/neutron_lbaas/tests/tempest/v2 -exec sed -i 's/127.0/128.0/g' {} \; 2>/dev/null

# clean up container files
find $DIR/tools -type f -exec chmod +x {} \;
chmod +x $DIR/run_tests.sh


