import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    //radius:50
    id:rightRoot
    //border.color: "white"
    //border.width: 0
    //opacity:1
    //color: "#33FF0000"
    property string targetId: targetSelector.currentItem ? targetSelector.currentItem.IdPlayer : "No selection"
    onTargetIdChanged: {
        globals.currentTarget.id = targetId;
        globals.currentTarget.distance = targetSelector.currentItem ? targetSelector.currentItem.Distance : 0;
        globals.currentTarget.azimuth = targetSelector.currentItem ? targetSelector.currentItem.Azimuth : 0;
        globals.currentTarget.name = targetSelector.currentItem ? targetSelector.currentItem.NamePlayer : targetId;
    }

    Column{
        opacity: 1
        anchors.fill:parent
        anchors.margins: Math.min(20, rightRoot.width*0.05)
        spacing:Math.min(20, rightRoot.width*0.1)
        property int rowHeight: (height - 2* spacing ) / 5


        SPSSpinButton{
             id:targetSelector
             width:parent.width
             height:parent.rowHeight
             model:playerModel
             roleToDisplayName:"NamePlayer"
             labelPrefix:"Target<br>"
        }



        Rectangle{
            id: skill
            width: parent.width
            height: 2 * parent.rowHeight
            radius: Math.min( 20, height * globals.ui.buttonRadiusPercHeight)
            color:globals.ui.buttonBkColor

            Text{
                text:"Steal !"
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.margins: globals.ui.buttonMargin
                color: globals.ui.textcolor
                font.pixelSize: globals.ui.textXL
                minimumPixelSize: globals.ui.minimumPixelSize
                fontSizeMode : Text.Fit
                font.family: "Syncopate"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment : Text.AlignVCenter
            }

        }

        WeaponButton{
            id:weapon
            width: parent.width
            height: 2 * parent.rowHeight
        }


    }

}


