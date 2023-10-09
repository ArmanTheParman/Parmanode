#Lists the virtual box containers
name=$(VBoxManage list vms | awk '{print $1}' | cut -d \" -f 2)

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
VBoxManage modifyvm "$name" --usb on --usbehci on --usbxhci on
vm_name="Umbrel_Drive"
VBoxManage usbfilter add 0 --target "$name" --name "$vm_name" --vendorid $vendorID --productid $productID 




vagrant up
vagrant ssh
