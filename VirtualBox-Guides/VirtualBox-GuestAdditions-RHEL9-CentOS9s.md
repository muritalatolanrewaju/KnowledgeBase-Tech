# VirtualBox-GuestAdditions-RHEL9-CentOS9s

Activate VirtualBox Copy/Paste on RHEL9/CentOS9s

## **1: Mount the Guest Additions ISO**

- Select Devices > Insert Guest Additions CD image on the VirtualBox menu bar.

- For GUI: Virtual CD will show up in the file explorer. Open and select `Run Software`.

- For CLI: Switch to `VBoxGuestAdditions` directory.

```bash
cd /run/media/`whoami`/VB*
```

- Run `VBoxGuestAdditions`

```
sudo ./VBoxLinuxAdditions.run
```

## **2: EPEL Installation**

### Enable CodeReady Linux Builder Repository

Enable the accessible CodeReady Linux Builder repository.

- On CentOS Stream 9:

```bash
sudo dnf config-manager --set-enabled crb
```

- On RHEL9:

```bash
sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
```

### EPEL Repo Installation

Install the EPEL RPM next.

- On CentOS Stream9:

```bash
sudo dnf install epel-release epel-next-release
```

- On RHEL9:

```bash
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
```

## **3: Install GuestAddition Tools Dependencies**

```bash
sudo dnf -y install gcc automake perl elfutils-libelf-devel dkms kernel-devel kernel-headers bzip2 libxcrypt-compat
```

- Restart the VM
 
```
sudo reboot
```

- Verify Virtualbox guest additions are correctly installed and operational

```
lsmod | grep vbox
```