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

# create neutron liberty validation environment
WORKDIR /
COPY init-neutron_liberty ./
RUN chmod +x ./init-neutron_liberty
RUN tempest init neutron_liberty
RUN virtualenv neutron_liberty
COPY neutron_liberty/ /neutron_liberty/
WORKDIR neutron_liberty
RUN /bin/bash install.sh
RUN rm -rf install.sh

# create lbaasv2 liberty validation environment
WORKDIR /
COPY init-lbaasv2_liberty ./
RUN chmod +x ./init-lbaasv2_liberty
RUN tempest init lbaasv2_liberty
RUN virtualenv lbaasv2_liberty
COPY lbaasv2_liberty/ /lbaasv2_liberty/
WORKDIR lbaasv2_liberty
RUN /bin/bash install.sh
RUN rm -rf install.sh

# create neutron mitaka validation environment
WORKDIR /
COPY init-neutron_mitaka ./
RUN chmod +x ./init-neutron_mitaka
RUN tempest init neutron_mitaka
RUN virtualenv neutron_mitaka
COPY neutron_mitaka/ /neutron_mitaka/
WORKDIR neutron_mitaka
RUN /bin/bash install.sh
RUN rm -rf install.sh

# create lbaasv2 mitaka validation environment
WORKDIR /
COPY init-lbaasv2_mitaka ./
RUN chmod +x ./init-lbaasv2_mitaka
RUN tempest init lbaasv2_mitaka
RUN virtualenv lbaasv2_mitaka
COPY lbaasv2_mitaka/ /lbaasv2_mitaka/
WORKDIR lbaasv2_mitaka
RUN /bin/bash install.sh
RUN rm -rf install.sh

# create lbaasv2 newton validation environment
#WORKDIR /
#COPY init-lbaasv2_newton ./
#RUN chmod +x ./init-lbaasv2_newton
#RUN tempest init lbaasv2_newton
#RUN virtualenv lbaasv2_newton
#COPY lbaasv2_newton/ /lbaasv2_newton/
#WORKDIR lbaasv2_newton
#RUN /bin/bash install.sh
#RUN rm -rf install.sh

# create lbaasv2 ocata validation environment
#WORKDIR /
#COPY init-lbaasv2_ocata ./
#RUN chmod +x ./init-lbaasv2_ocata
#RUN tempest init lbaasv2_ocata
#RUN virtualenv lbaasv2_ocata
#COPY lbaasv2_ocata/ /lbaasv2_ocata/
#WORKDIR lbaasv2_ocata
#RUN /bin/bash install.sh
#RUN rm -rf install.sh

# create image importer
WORKDIR /
COPY init-image_importer ./
RUN chmod +x ./init-image_importer
RUN mkdir image_importer
COPY image_importer/bigip_image_import.py /image_importer/bigip_image_import.py
COPY image_importer/bigip_image_importer_webserver.yaml /image_importer/bigip_image_importer_webserver.yaml 

WORKDIR /
# run interactively
CMD /bin/bash 
