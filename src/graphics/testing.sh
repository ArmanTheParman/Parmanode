function testing {


#make xml file
echo '<?xml version="1.0"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="application/x-dummy">
        <comment>Dummy MIME Type Example</comment>
        <icon name="dummy_icon.png"/>
        <glob pattern="*.dummy"/>
    </mime-type>
</mime-info>' | sudo tee /usr/share/mime/packages/x-dummy.xml 

sudo update-mime-database /usr/share/mime/

mkdir -p ~/.icons/
sudo cp pn_icon.png /usr/share/icons/dummy_icon.png
touch ~/Desktop/d.dummy #why does the icon association not work for this file?

echo '[Desktop Entry]
Version=1.0
Type=Application
Name=Dummy File
Comment=Open dummy files
Icon=/home/usr/share/icons/dummy_icon.png
Exec=/home/parman/Desktop/d.dummy %f
Terminal=true
Categories=Application;' | sudo tee /usr/share/applications/dummy.desktop

sudo chmod +x /usr/share/applications/dummy.desktop

sudo update-desktop-database /usr/share/applications/


}
function testing_delete {

sudo rm /usr/share/mime/packages/*dummy* ~/.icons/*dummy* ~/Desktop/*dummy* /usr/share/icons/*dummy* /usr/share/mime/application/*dummy*
sudo rm /usr/share/applications/*dummy*
}

function t2 {

mkdir -p ~/.icons/
sudo cp pn_icon.png ~/.icons/pn.pn
touch ~/Desktop/run_parmanode-pn.sh


}

function t3 {
mkdir -p ~/.icons/
cp /home/parman/coding/parmanode/src/graphics/pn_icon.png /home/parman/.icons/pn_icon.png
echo '[Desktop Entry]
Type=Application
Exec=/home/parman/Desktop/run_parmanode.pn
Name=ParmaNode
Icon=/home/parman/.icons/pn_icon.png
Terminal=true
Categories=Utility;Application;' | sudo tee /usr/share/applications/parmanode.desktop

sudo chmod +x /usr/share/applications/parmanode.desktop

}

function undot3 {

sudo rm ~/.icons/pn_icon.png
sudo rm /usr/share/applications/parmanode.desktop


}