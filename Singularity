Bootstrap: shub
#From: ubuntu:xenial
From: vfonov/minc-toolkit-containers:1.9.16

###################################################################
#                                                                 #
# MCIN (McGill Centre for Integrative Neuroscience)               #
#                                                                 #
# Singularity recipe for minc-bpipe-library to build a container  #
# used in CBRAIN (https://github.com/aces/cbrain)                 #
#                                                                 #
###################################################################

%labels
  Maintainer Shawn Brown 

%help
This container provides minc-bpipe-library

%post
  apt-get update  -y
  apt-get install -y automake
  apt-get install -y build-essential 
  apt-get install -y curl
  apt-get install -y git
  apt-get install -y libnetcdf-dev  
  apt-get install -y libhdf5-dev
  apt-get install -y parallel
  apt-get install -y vim
  apt-get install -y wget
  apt-get install -y parallel
  apt-get install -y default-jre
  apt-get install -y default-jdk
  
  curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
  apt-get install -y python
  python get-pip.py 
  pip install pyminc scipy
  pip install qbatch 
  pip install future

### Install Bpipe
  export TERM=dumb
  cd / 
  #git clone https://github.com/ssadedin/bpipe.git
  wget -P /tmp http://download.bpipe.org/versions/bpipe-0.9.9.6.tar.gz ; tar -xvzf /tmp/bpipe-0.9.9.6.tar.gz ; rm -rf /tmp/bpipe-0.9.9.6.tar.gz 
  ln -sf /bpipe-0.9.9.6 /bpipe
  cd /bpipe

### get minc-to-bpipe 
  cd /
  git clone https://github.com/CobraLab/minc-bpipe-library.git
  rm -rf /minc-bpipe-library/bpipe.config
 
%environment
  PATH=/bpipe/bin:$PATH

%runscript

