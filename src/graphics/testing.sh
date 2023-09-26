function testing {


#make xml file
echo '<?xml version="1.0"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="application/x-dummy">
        <comment>Dummy MIME Type Example</comment>
        <icon name="dummy_icon"/>
        <glob pattern="dummyfile.dummy"/>
    </mime-type>
</mime-info>' | sudo tee /usr/share/mime/packages/x-dummy.xml 

sudo update-mime-database /usr/share/mime/

mkdir -p ~/.icons/
cp pn_icon.png ~/.icons/dummy_icon.png
touch ~/Desktop/d.dummy

}
function testing_delete {

sudo rm /usr/share/mime/packages/*dummy* ~/.icons/*dummy* ~/Desktop/*dummy*

}