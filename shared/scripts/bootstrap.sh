# Download latest package information
sudo apt update

# Get JDK
sudo wget https://download.oracle.com/java/18/latest/jdk-18_linux-x64_bin.deb -P /tmp

# Install JDK
sudo dpkg -i /tmp/jdk-18_linux-x64_bin.deb

# Set Alternative
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-18/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-18/bin/javac 1
sudo update-alternatives --config java

# Set JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/jdk-18

source /etc/environment

# Get Maven
sudo wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.5/apache-maven-3.8.5-bin.tar.gz -P /usr

# Unzip Maven
sudo tar -xf /usr/apache-maven-3.8.5-bin.tar.gz -C /usr

# Set Alternative
sudo update-alternatives --install /usr/bin/mvn maven /usr/apache-maven-3.8.5/bin/mvn 1001

# Set Maven Environment Variables
export MAVEN_HOME=/usr/apache-maven-3.8.5
export M2_HOME=/usr/apache-maven-3.8.5
export PATH=${MAVEN_HOME}/bin:${PATH}

# Cleanup
sudo rm -f /tmp/jdk-18_linux-x64_bin.deb
sudo rm -f /usr/apache-maven.3.8.5-bin.tar.gz