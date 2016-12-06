#!/bin/bash
apt-get -y update
apt-get -y install apache2
cat <<EOF > /var/www/html/index.html
<html>
<body>
<p>TEAM 0 USER_DATA WORKS - hostname is: $(hostname)</p>
</body>
</html>
EOF
