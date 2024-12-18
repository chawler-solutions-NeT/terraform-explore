#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install java-1.8.0-openjdk-devel -y #-----------> use this is for Amazon linux 2 down
#sudo dnf install java-11-amazon-corretto -y
sudo groupadd --system tomcat
sudo useradd -d /usr/share/tomcat -r -s /bin/false -g tomcat tomcat
sudo yum install wget git -y
cd /opt
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
sudo tar -xzf apache-maven-3.9.9-bin.tar.gz && sudo rm apache-maven-3.9.9-bin.tar.gz
sudo mv apache-maven-3.9.9/ apache-maven
sudo echo 'PATH="/opt/apache-maven/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' | sudo tee /etc/environment
source /etc/environment
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz
sudo tar -xvf apache-tomcat-9.0.98.tar.gz
sudo mv apache-tomcat-9.0.98 tomcat9
sudo rm -rf apache-tomcat-9.0.98.tar.gz
sudo chown -R tomcat:tomcat /opt/tomcat9
sed -i.bak '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/ s/^/<!-- /; /0:0:0:0:0:0:0:1" \/>/ s/$/ -->/' /opt/tomcat9/webapps/manager/META-INF/context.xml
sed -i.bak '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/ s/^/<!-- /; /0:0:0:0:0:0:0:1" \/>/ s/$/ -->/' /opt/tomcat9/webapps/host-manager/META-INF/context.xml
sed -i 's/<Connector port="8080" protocol="HTTP\/1.1"/<Connector port="8085" protocol="HTTP\/1.1"/' /opt/tomcat9/conf/server.xml
sed -i.bak '/<\/tomcat-users>/i \
<role rolename="manager-gui"/> \
<role rolename="admin-gui"/> \
<role rolename="manager-status"/> \
<user username="admin" password="admin@123" roles="manager-gui,admin-gui,manager-status,manager-script"/> \
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

echo "[Unit]
Description=Spring Petclinic Application
After=network.target

[Service]
User=tomcat
Group=tomcat
ExecStart=/usr/bin/java -jar /opt/tomcat9/webapps/spring-petclinic-2.4.2.war
WorkingDirectory=/opt/tomcat9/webapps/
Restart=always
RestartSec=10
StandardOutput=file:/var/log/spring-petclinic.log
StandardError=file:/var/log/spring-petclinic-error.log
Environment=JAVA_OPTS="-Xmx512m -Xms256m"

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/petclinic.service

# sudo nohup java -jar /opt/tomcat9/webapps/spring-petclinic-2.4.2.war &
#screen -dmS petadoption sudo java -jar /opt/tomcat9/webapps/spring-petclinic-2.4.2.war &

# Start the Web service
sudo systemctl start tomcat
sudo systemctl start petclinic

sudo systemctl enable petclinic
sudo systemctl enable tomcat

sleep 120
# Try to fetch the public key from SSM and add it to authorized_keys
for i in {1..5}; do
    PUBLIC_KEY=$(aws ssm get-parameter --name /sand/public_key --with-decryption --query "Parameter.Value" --output text --region us-east-1 2>/dev/null)
    if [ -n "$PUBLIC_KEY" ]; then
        echo "$PUBLIC_KEY" | sudo tee -a /home/ec2-user/.ssh/authorized_keys > /dev/null
        echo "Public key added successfully to authorized_keys."
        break
    else
        echo "Attempt $i: Failed to retrieve public key"
        sleep 30
    fi
done

if [ -z "$PUBLIC_KEY" ]; then
    echo "Failed to retrieve public key"
fi