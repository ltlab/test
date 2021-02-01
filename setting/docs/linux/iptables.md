# iptables and fail2ban

## Install Packages

  ```sh
  sudo apt update
  sudo apt -y -qq install fail2ban
  sudo apt -y -qq install iptables-persistent netfilter-persistent
   ```

## Commands

- `fail2ban` configuration

  ```sh
  sudo vi /etc/fail2ban/jail.conf

  bantime = 360m
  findtime = 360m
  mxretry = 3
  ```

- `iptables` rules
  ```sh
  sudo ufw disable

  #sudo iptables -A INPUT -i lo -j ACCEPT
  sudo iptables -A INPUT -p tcp -s 192.168.0.0/16 --dport 22 -j ACCEPT
  sudo iptables -A INPUT -p tcp -s 222.96.0.0/12 --dport 22 -j ACCEPT
  sudo iptables -A INPUT -p tcp -s 115.88.0.0/13 --dport 22 -j ACCEPT
  sudo iptables -A INPUT -p tcp --dport 22 -j DROP
  ```

- Save `iptables` rules

  ```sh
  sudo netfilter-persistent save`
  sudo netfilter-persistent restart`
  ```

- Services and check status
  ```sh
  sudo service iptables start
  sudo service iptables stop
  sudo service iptables restart
  sudo service iptables save

  sudo fail2ban-client status sshd
  ```
