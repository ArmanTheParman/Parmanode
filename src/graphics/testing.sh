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

}
function testing_delete {

sudo rm /usr/share/mime/packages/*dummy* ~/.icons/*dummy* ~/Desktop/*dummy* /usr/share/icons/*dummy* /usr/share/mime/application/*dummy*

}

function t2 {

mkdir -p ~/.icons/
sudo cp pn_icon.png ~/.icons/pn.pn
touch ~/Desktop/run_parmanode-pn.sh


}