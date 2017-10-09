# Initial Deployment

Perform these steps once for each PC/user that you deploy the workshop to.  This will download the box file from the server and add it to the Vagrant cache.

1. Add the box to the Vagrant cache  
```bash
vagrant box add http://jenkins.windhoverlabs.lan/releases/workshop/workshop.json
```
2. Verify the box is added.  You should output similar to the following output, though the version number will change as the box is updated.  
```
==> box: Loading metadata for box 'http://jenkins.windhoverlabs.lan/workshop/workshop.json'
==> box: Adding box 'workshop' (v0.0.1) for provider: virtualbox
    box: Downloading: http://jenkins.windhoverlabs.lan/workshop/workshop_0.0.1.box
    box: Progress: 100% (Rate: 83.5M/s, Estimated time remaining: --:--:--)
    box: Calculating and comparing box checksum...
==> box: Successfully added box 'workshop' (v0.0.1) for 'virtualbox'!
```

# Instance Deployment

Perform these steps everytime you want to deploy a new instance of Workshop.  This will create a new virtual machine from the cached source.

1. Create a directory to deploy Workshop, i.e.:  
```bash
mkdir workshop
```
2. Make the new directory the working directory:  
```bash
cd workshop
```
3. Instantiate the Workshop instance.  This will create a "Vagrantfile" in your new directory.  
```bash
vagrant init workshop
```
4. Tailor the instance for your PC and uses.  Edit the "Vagrantfile" file to apply new tailoring.  For example, it is common to enable the GUI and increase the allocated memory and CPUs:  
```
    config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = true
  
      # Customize the amount of memory on the VM:
      vb.memory = "8192"
      
      # Customize the number of CPUs on the VM:
      vb.cpus = "2"
    end
```
5. Save the file and run the following command to create the instance and launch the new Workshop instance for the first time:  
```
vagrant up
```
6. This can take a few minutes to complete initially.  You should see output similar to the following (though some details will change, i.e. VM name, paths, and forwarding ports):  
```
    Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'workshop'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'workshop' is up to date...
==> default: Setting the name of the VM: workshop_default_1496071265099_5561
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => C:/Users/mathe_g0df2an/Documents/windhover/repos/workshop
```
7.  If you enabled the GUI, VirtualBox should open with a view of the Workshop desktop.

# How to start Workshop

1. To start Workshop, open a terminal, navigate to the directory where you created the Workshop instance, and run the following command:  
```
vagrant up
```
2. It shouldn't take more than 30 seconds to start and you should see output similar to the following:  
```
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Checking if box 'workshop' is up to date...
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => C:/Users/mathe_g0df2an/Documents/windhover/repos/workshop
==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> default: flag to force provisioning. Provisioners marked to run always will still run.
```
    Take special note of the line that t reads "Checking if box 'workshop' is up to date".  If there is a new version on the server, you will see a message indicating such.  Upgrade to the new version is not automatic.  See section "How to Upgrade Workshop" for instructions on how to upgrade your instance.

# How to shutdown Workshop

Though Workshop could be left running indefinitely, you should shutdown workshop when not in use to ensure that no data will be lost if power is lost or the host is unexpected shutdown.

1. To shutdown Workshop, save all files you have open in the Workshop virtual machine.
2. Next open a terminal on the host PC not the Workshop virtual machine, navigate to the directory where you created the Workshop instance, and run the following command:  
```
vagrant halt
```
3. You should see the following output in the host terminal:  
```
==> default: Attempting graceful shutdown of VM...
```
    
# How to upgrade Workshop

The "vagrant up" command will always try to query the source server for the latest version of Workshop.  If a newer version exists, it will output a message indicating such, but it will not automatically upgrade the instance.  This gives you the chance to prepare for the upgrade first and perform the upgrade at your convenience.

Upgrading Workshop will delete the Workshop instance and any data contained within Workshop.  Therefore, all files that you want to save should be saved off before performing the following steps.  Any changes in CM repositories should be pushed to the server.  For convenience, the "/vagrant" directory is mapped back to the host.  It is common to copy files you want to retain to the /vagrant directory.  Often, users will just do all work in the /vagrant directory to ensure files are always retained.  However, when running Workshop on a Windows host, this is sometimes problematic due to differences in the Windows file system.  Therefore, it is recommended that Windows users should use the home directory in Workshop, and only copy tarballs (.tar.gz) to the /vagrant directory.  This is because while permissions and file attributes of the tarball itself are lost when copied to the Windows file system, the contents of the tarball can still be safely untar'd back onto the new Workshop instance linux file system with all the correct permissions and file attributes retained.
 
1. Shutdown the Workshop instance.  
2. Run the following command:  
```
vagrant box update
vagrant destroy
vagrant up
```
