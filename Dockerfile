FROM centos:7.3.1611
MAINTAINER John Gruber "j.gruber@f5.com"

# add the CentOS Mitaka repo
RUN yum -y install centos-release-openstack-mitaka
RUN yum -y update
RUN yum -y groups mark install "Development Tools"
RUN yum -y groups mark convert "Development Tools"
RUN yum -y groupinstall "Development Tools"
RUN yum -y install openssl-devel libffi libffi-devel python-devel git python-pip python-openstackclient python-heatclient

# update key python libraries
RUN pip install --upgrade pip setuptools virtualenv tempest ipython

# add f5-openstack-agent libraries
RUN git clone -b mitaka https://github.com/F5Networks/f5-openstack-agent.git
RUN pip install /f5-openstack-agent/
RUN rm -rf /f5-openstack-agent

# copy init environment functions
COPY init-functions ./
COPY init-neutron_validate ./
RUN chmod +x ./init-neutron_validate
COPY init-lbaasv2_liberty ./
RUN chmod +x ./init-lbaasv2_liberty
COPY init-lbaasv2_mitaka ./
RUN chmod +x ./init-lbaasv2_mitaka
COPY init-lbaasv2_newton ./
RUN chmod +x ./init-lbaasv2_newton
COPY init-lbaasv2_ocata ./
RUN chmod +x ./init-lbaasv2_ocata
COPY init-image_importer ./
RUN chmod +x ./init-image_importer

# create lbaasv2 liberty validation environment
RUN tempest init lbaasv2_liberty
RUN virtualenv lbaasv2_liberty
WORKDIR lbaasv2_liberty
RUN git clone https://github.com/openstack/neutron.git
RUN /bin/bash -c "cd /lbaasv2_liberty/neutron \
    && git fetch --all \
    && git checkout -b liberty liberty-eol"
RUN mv ./neutron/neutron ./neutron-python
RUN rm -rf ./neutron
RUN mv ./neutron-python ./neutron
RUN git clone https://github.com/openstack/neutron-lbaas.git
RUN /bin/bash -c "cd /lbaasv2_liberty/neutron-lbaas \
    && git fetch --all \
    && git checkout -b liberty liberty-eol"
RUN mkdir neutron_lbaas
RUN cp -Rf ./neutron-lbaas/neutron_lbaas/* ./neutron_lbaas
RUN /bin/bash -c "cd /lbaasv2_liberty \
    && source ./bin/activate \
    && pip install -r ./neutron-lbaas/requirements.txt \
    && pip install -r ./neutron-lbaas/test-requirements.txt \
    && mkdir /lbaasv2_liberty/tempest_lib \
    && cp -Rf /lbaasv2_liberty/lib/python2.7/site-packages/tempest_lib/* /lbaasv2_liberty/tempest_lib/ \
    && pip install --upgrade eventlet tempest f5-openstack-agent pyopenssl"
COPY lbaasv2_liberty/dot_testr.conf /lbaasv2_liberty/.testr.conf
COPY lbaasv2_liberty/f5-agent.conf /lbaasv2_liberty/etc/
COPY lbaasv2_liberty/tempest.conf /lbaasv2_liberty/etc/
RUN mkdir /lbaasv2_liberty/tools/
COPY lbaasv2_liberty/tools/clean-os-from-testing.sh /lbaasv2_liberty/tools/clean-os-from-testing.sh
RUN chmod +x /lbaasv2_liberty/tools/clean-os-from-testing.sh
COPY lbaasv2_liberty/tools/clean_bigip.py /lbaasv2_liberty/tools/clean_bigip.py
COPY lbaasv2_liberty/tools/clean-bigip-from-testing.sh /lbaasv2_liberty/tools/clean-bigip-from-testing.sh
RUN chmod +x /lbaasv2_liberty/tools/clean-bigip-from-testing.sh
COPY lbaasv2_liberty/tools/clean /lbaasv2_liberty/tools/clean
RUN chmod +x /lbaasv2_liberty/tools/clean
COPY lbaasv2_liberty/tools/populate-conf-from-env /lbaasv2_liberty/tools/populate-conf-from-env
RUN chmod +x /lbaasv2_liberty/tools/populate-conf-from-env
RUN find /lbaasv2_liberty/neutron_lbaas/tests/tempest -exec sed -i 's/127.0.0.1/128.0.0.1/g' {} \; 2>/dev/null

# create lbaasv2 mitaka validation environment
WORKDIR /
RUN tempest init lbaasv2_mitaka
RUN virtualenv lbaasv2_mitaka
WORKDIR lbaasv2_mitaka
RUN git clone -b stable/mitaka https://github.com/openstack/neutron-lbaas.git
RUN mkdir neutron_lbaas
RUN cp -Rf ./neutron-lbaas/neutron_lbaas/* ./neutron_lbaas
RUN /bin/bash -c "cd /lbaasv2_mitaka \
    && source ./bin/activate \
    && pip install -r ./neutron-lbaas/requirements.txt \
    && pip install -r ./neutron-lbaas/test-requirements.txt \
    && pip install -r ./neutron_lbaas/tests/tempest/requirements.txt \
    && mkdir /lbaasv2_mitaka/tempest \
    && cp -Rf /lbaasv2_mitaka/lib/python2.7/site-packages/tempest/* /lbaasv2_mitaka/tempest/ \
    && pip install --upgrade tempest f5-openstack-agent"
COPY lbaasv2_mitaka/dot_testr.conf /lbaasv2_mitaka/.testr.conf
COPY lbaasv2_mitaka/f5-agent.conf /lbaasv2_mitaka/etc/
COPY lbaasv2_mitaka/tempest.conf /lbaasv2_mitaka/etc/
RUN mkdir /lbaasv2_mitaka/tools/
COPY lbaasv2_mitaka/tools/clean-os-from-testing.sh /lbaasv2_mitaka/tools/clean-os-from-testing.sh
RUN chmod +x /lbaasv2_mitaka/tools/clean-os-from-testing.sh
COPY lbaasv2_mitaka/tools/clean_bigip.py /lbaasv2_mitaka/tools/clean_bigip.py
COPY lbaasv2_mitaka/tools/clean-bigip-from-testing.sh /lbaasv2_mitaka/tools/clean-bigip-from-testing.sh
RUN chmod +x /lbaasv2_mitaka/tools/clean-bigip-from-testing.sh
COPY lbaasv2_mitaka/tools/clean /lbaasv2_mitaka/tools/clean
RUN chmod +x /lbaasv2_mitaka/tools/clean
COPY lbaasv2_mitaka/tools/populate-conf-from-env /lbaasv2_mitaka/tools/populate-conf-from-env
RUN chmod +x /lbaasv2_mitaka/tools/populate-conf-from-env
RUN find /lbaasv2_mitaka/neutron_lbaas/tests/tempest -exec sed -i 's/127.0.0.1/128.0.0.1/g' {} \; 2>/dev/null

# create lbaasv2 newton validation environment
WORKDIR /
RUN tempest init lbaasv2_newton
RUN virtualenv lbaasv2_newton
WORKDIR lbaasv2_newton
RUN git clone -b stable/newton https://github.com/openstack/neutron-lbaas.git
RUN mkdir neutron_lbaas
RUN cp -Rf ./neutron-lbaas/neutron_lbaas/* ./neutron_lbaas
RUN /bin/bash -c "cd /lbaasv2_newton \
    && source ./bin/activate \
    && pip install -r ./neutron-lbaas/requirements.txt \
    && pip install -r ./neutron-lbaas/test-requirements.txt \
    && pip install f5-openstack-agent"
COPY lbaasv2_newton/dot_testr.conf /lbaasv2_newton/.testr.conf
COPY lbaasv2_newton/f5-agent.conf /lbaasv2_newton/etc/
COPY lbaasv2_newton/tempest.conf /lbaasv2_newton/etc/
RUN mkdir /lbaasv2_newton/tools/
COPY lbaasv2_newton/tools/clean-os-from-testing.sh /lbaasv2_newton/tools/clean-os-from-testing.sh
RUN chmod +x /lbaasv2_newton/tools/clean-os-from-testing.sh
COPY lbaasv2_newton/tools/clean_bigip.py /lbaasv2_newton/tools/clean_bigip.py
COPY lbaasv2_newton/tools/clean-bigip-from-testing.sh /lbaasv2_newton/tools/clean-bigip-from-testing.sh
RUN chmod +x /lbaasv2_newton/tools/clean-bigip-from-testing.sh
COPY lbaasv2_newton/tools/clean /lbaasv2_newton/tools/clean
RUN chmod +x /lbaasv2_newton/tools/clean
COPY lbaasv2_newton/tools/populate-conf-from-env /lbaasv2_newton/tools/populate-conf-from-env
RUN chmod +x /lbaasv2_newton/tools/populate-conf-from-env
RUN find /lbaasv2_newton/neutron_lbaas/tests/tempest -exec sed -i 's/127.0.0.1/128.0.0.1/g' {} \; 2>/dev/null

# create lbaasv2 ocata validation environment
WORKDIR /
RUN tempest init lbaasv2_ocata
RUN virtualenv lbaasv2_ocata
WORKDIR lbaasv2_ocata
RUN git clone -b stable/ocata https://github.com/openstack/neutron-lbaas.git
RUN mkdir neutron_lbaas
RUN cp -Rf ./neutron-lbaas/neutron_lbaas/* ./neutron_lbaas
RUN /bin/bash -c "cd /lbaasv2_ocata \
    && source ./bin/activate \
    && pip install -r ./neutron-lbaas/requirements.txt \
    && pip install -r ./neutron-lbaas/test-requirements.txt \
    && pip install f5-openstack-agent"
COPY lbaasv2_ocata/dot_testr.conf /lbaasv2_ocata/.testr.conf
COPY lbaasv2_ocata/f5-agent.conf /lbaasv2_ocata/etc/
COPY lbaasv2_ocata/tempest.conf /lbaasv2_ocata/etc/
RUN mkdir /lbaasv2_ocata/tools/
COPY lbaasv2_ocata/tools/clean-os-from-testing.sh /lbaasv2_ocata/tools/clean-os-from-testing.sh
RUN chmod +x /lbaasv2_ocata/tools/clean-os-from-testing.sh
COPY lbaasv2_ocata/tools/clean_bigip.py /lbaasv2_ocata/tools/clean_bigip.py
COPY lbaasv2_ocata/tools/clean-bigip-from-testing.sh /lbaasv2_ocata/tools/clean-bigip-from-testing.sh
RUN chmod +x /lbaasv2_ocata/tools/clean-bigip-from-testing.sh
COPY lbaasv2_ocata/tools/clean /lbaasv2_ocata/tools/clean
RUN chmod +x /lbaasv2_ocata/tools/clean
COPY lbaasv2_ocata/tools/populate-conf-from-env /lbaasv2_ocata/tools/populate-conf-from-env
RUN chmod +x /lbaasv2_ocata/tools/populate-conf-from-env
RUN find /lbaasv2_ocata/neutron_lbaas/tests/tempest -exec sed -i 's/127.0.0.1/128.0.0.1/g' {} \; 2>/dev/null

# create image importer
RUN mkdir image_importer
COPY image_importer/bigip_image_import.py /image_importer/bigip_image_import.py
COPY image_importer/bigip_image_importer_webserver.yaml /image_importer/bigip_image_importer_webserver.yaml 

WORKDIR /
# run interactively
CMD /bin/bash 

