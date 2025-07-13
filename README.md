# k8s-on-macos

Based on https://github.com/louhisuo/k8s-on-macos/

## Dependencies

Configure bootp:

```bash
sudo cp assets/bootptab /etc/bootptab
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --remove /usr/libexec/bootpd
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/libexec/bootpd
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblock /usr/libexec/bootpd
sudo /bin/launchctl kickstart -kp system/com.apple.bootpd
```

Install packages:

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install go lima kubernetes-cli helm
```

Adjust `~/.lima/_config/networks.yaml` as follows:
- `socketVMNet` set to `/opt/socket_vmnet/bin/socket_vmnet`
- `dhcpEnd` reduced to `192.168.x.99`

Install socket_vmnet support (do not install launchd daemon!):

```bash
git clone https://github.com/lima-vm/socket_vmnet.git
cd socket_vmnet
git checkout v1.2.1
sudo make install.bin
limactl sudoers | sudo tee /etc/sudoers.d/lima
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$USER"
```

Run `templates.sh` to download lima OS VMs templates.

Run `create_vms.sh` to create lima OS VMs.

Run `start_servers.sh` to start Kubernetes control planes.

Run `start_workers.sh` to start Kubernetes workers.

Run `setup.sh` to install helm charts.

Run `clean.sh` to terminate all previously created VMs.
