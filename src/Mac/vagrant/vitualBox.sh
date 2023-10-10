return 0
#Lists the virtual box containers
name=$(VBoxManage list vms | awk '{print $1}' | cut -d \" -f 2)
name=ParmanodeVM
#Lists all the usb devices attached to the host
    #disconnect drive
    VBoxManage list usbhost > ./before
    #connect drive
    VBoxManage list usbhost > ./after

vendorID=$(diff -U0 before after | grep Vendor | awk '{print $2}')
productID=$(diff -U0 before after | grep ProductId | awk '{print $2}')
########################################################################################

Vagrant halt
#enable USB 1.1, 2.0, 3.0 respectively...
VBoxManage modifyvm "Parmanode" --usb on --usbehci on --usbxhci on
vm_name="Umbrel_Drive"
VBoxManage usbfilter add 0 --target "ParmanodeVM" --name "P_drive" --vendorid $vendorID --productid $productID 
Vagrant reload



vagrant ssh
