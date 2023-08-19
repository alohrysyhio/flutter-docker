# Please read.

## Who's this for ?
Mainly for fedora users, and the reason is that I only know how to make android physical devices work on fedora, they might be working by default in other distros, you can try.

## How to use ?

### Step 1 (if your going to use a physical device for develepment):
**- Enable USB debugging on your phone and connect it to your PC via USB.**
```
lsusb
```
**- Look for your device and keep the two numbers after "ID".**
```
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="XXXX", ATTR{idProduct}=="YYYY", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android.rules > /dev/null && sudo service udev restart
```
**- Replace XXXX and YYYY with the IDs of you're device.**\
**- Open Dockerfile and look for the same command that you entered and also change the XXXX and YYYY with you device's IDs.**

### Step 2:
**- Put the .devcontainer/ folder in your project directory.**
Idealy you should have the Dev Containers extention installed in VScode. Then you can just reopen the floder in the container and everything should hopefully be working.