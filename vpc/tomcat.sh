#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
# yum install java-1.8.0-openjdk-devel -y #-----------> use this is for Amazon linux 2 down
sudo dnf install java-11-amazon-corretto -y
sudo groupadd --system tomcat
sudo useradd -d /usr/share/tomcat -r -s /bin/false -g tomcat tomcat
sudo yum install wget git maven -y
cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.87/bin/apache-tomcat-9.0.87.tar.gz
sudo tar -xvf apache-tomcat-9.0.87.tar.gz
sudo mv apache-tomcat-9.0.87 tomcat9
sudo rm -rf apache-tomcat-9.0.87.tar.gz
sudo chown -R tomcat:tomcat /opt/tomcat9
sudo sed -i.bak '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/ s/^/<!-- /; /0:0:0:0:0:0:0:1" \/>/ s/$/ -->/' /opt/tomcat9/webapps/manager/META-INF/context.xml
sudo sed -i.bak '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/ s/^/<!-- /; /0:0:0:0:0:0:0:1" \/>/ s/$/ -->/' /opt/tomcat9/webapps/host-manager/META-INF/context.xml
sudo sed -i.bak 's/<Connector port="8080" protocol="HTTP\/1.1"/<Connector port="8085" protocol="HTTP\/1.1"/' /opt/tomcat9/conf/server.xml
sudo sed -i.bak '/<\/tomcat-users>/i \
<role rolename="manager-gui"/> \
<role rolename="admin-gui"/> \
<role rolename="manager-status"/> \
<user username="admin" password="admin@123" roles="manager-gui,admin-gui,manager-status"/> \
' /opt/tomcat9/conf/tomcat-users.xml
# Create the service file
echo "[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
User=tomcat
Group=tomcat
Type=forking
ExecStart=/opt/tomcat9/bin/startup.sh
ExecStop=/opt/tomcat9/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/tomcat.service
cd
git clone https://github.com/chawler-solutions-NeT/petadoption-springboot
cd petadoption-springboot
mvn clean install -Dmaven.test.skip=true -Dcheckstyle.skip
sudo cp ./target/spring-petclinic-2.4.2.war /opt/tomcat9/webapps/
sudo nohup java -jar /opt/tomcat9/webapps/spring-petclinic-2.4.2.war &

# Start the Tomcat service
sudo systemctl start tomcat
# # Enable the Tomcat service to start on boot
sudo systemctl enable tomcat
