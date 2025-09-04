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
brew install go lima kubernetes-cli helm cilium-cli
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

Run `01-templates.sh` to download lima OS VMs templates.

Run `02-create_vms.sh` to create lima OS VMs.

Run `03-start_servers.sh` to start Kubernetes control planes.

Run `04-start_workers.sh` to start Kubernetes workers.

Run `05-setup.sh` to install helm charts.

Run `06-stop.sh` to stop all previously created VMs or run `07-clean.sh` to
terminate them.

> By default only one control-plane node is enabled. If you need more than one,
> uncomment them in `02-create_vms.sh`, `03-start_servers.sh`, `06-stop.sh`, and
> `07-clean.sh`.
