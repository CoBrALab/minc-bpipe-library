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

### Install latest verion of cmake
  #apt remove cmake -y
  #apt purge --auto-remove cmake

  version=3.12
  build=3
  mkdir ~/temp
  cd ~/temp
  wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz
  tar -xzvf cmake-$version.$build.tar.gz
  cd cmake-$version.$build/
  ./bootstrap
  make 
  make install 

### Install Minc-stuffs
  git clone --recursive https://github.com/Mouse-Imaging-Centre/minc-stuffs.git /minc-stuffs && \
  cd /minc-stuffs                                                                            && \
  ./autogen.sh                                                                                 && \
  ./configure --prefix=/opt CPPFLAGS="-I/usr/include/hdf5/serial -I/opt/minc/1.0.09/include" LDFLAGS="-L/opt/minc/1.0.09/lib -L/usr/lib/hdf5/serial" &&\
  make                                                                                       && \
  make install                                                                               && \
  python setup.py install

### Install ANTs
  cd /
  git clone https://github.com/ANTsX/ANTs.git
 
  mkdir /bin/ants
  cd /bin/ants
  cmake /ANTs
  make 
   
### Install Bpipe
  export TERM=dumb
  cd / 
  git clone https://github.com/ssadedin/bpipe.git
  cd /bpipe
  ./gradlew clean jar
 
%environment
  PATH=/bin/ants/bin:/bpipe/bin:$PATH

%runscript

