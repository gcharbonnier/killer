import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    //radius:50
    id:rightRoot
    //border.color: "white"
    //border.width: 0
    //opacity:1
    //color: "#33FF0000"




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
             //currentSelection: globals.currentTarget.modelIndex
             onCurrentItemChanged:  {
                 if (currentItem)
                 {
                     globals.currentTarget.id = currentItem.currentData.IdPlayer;
                     globals.currentTarget.distance = currentItem.currentData.Distance;
                     globals.currentTarget.azimuth = currentItem.currentData.Azimuth;
                     globals.currentTarget.name = currentItem.currentData.NamePlayer;

                     globals.currentTarget.health = currentItem.currentData.Health;
                     globals.currentTarget.credits = currentItem.currentData.Credits;
                     globals.currentTarget.xp = currentItem.currentData.Xp;
                     globals.currentTarget.energy = currentItem.currentData.Energy;
                     globals.currentTarget.level = currentItem.currentData.Level;
                 }
             }
             Binding{
                 target:targetSelector
                 property:"currentSelection"
                 value:globals.currentTarget.modelIndex
             }


        }

        SkillButton{
            id: skill
            width: parent.width
            height: 2 * parent.rowHeight

        }

        WeaponButton{
            id:weapon
            width: parent.width
            height: 2 * parent.rowHeight
        }


    }

}


