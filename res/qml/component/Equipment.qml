import QtQuick 2.3

import MyEnums 1.0
import "../../../GameLogic.js" as EquipmentAction

Item{
    id:stuffPanel
    property int currentTypeFilter : -1
    height: parent.height
    width: parent.width*0.5



    Row{
        id: filterMenu
        height: parent.height * 0.15
        width:parent.width
        spacing : 5
        SPSButtonText{
            height:parent.height
            width : height
            text:qsTr("All")
            color: stuffPanel.currentTypeFilter == -1 ? "blue" : "orange"
            onClicked: stuffPanel.currentTypeFilter = -1;
        }
        SPSButtonText{
            text:qsTr("Weapons")
            height:parent.height
            width : height
            color: stuffPanel.currentTypeFilter == Enums.Weapon ? "blue" : "orange"
            onClicked: stuffPanel.currentTypeFilter = Enums.Weapon;
        }
        SPSButtonText{
            text:qsTr("Ammonitions")
            height:parent.height
            width : height
            color: stuffPanel.currentTypeFilter == Enums.Ammo ? "blue" : "orange"
            onClicked: stuffPanel.currentTypeFilter = Enums.Ammo;
        }
        SPSButtonText{
            text:qsTr("Consumable")
            height:parent.height
            width : height
            color: stuffPanel.currentTypeFilter == Enums.Consumable ? "blue" : "orange"
            onClicked: stuffPanel.currentTypeFilter = Enums.Consumable;
        }
        SPSButtonText{
            text:qsTr("Special")
            height:parent.height
            width : height
            color: stuffPanel.currentTypeFilter == Enums.Special ? "blue" : "orange"
            onClicked: stuffPanel.currentTypeFilter = Enums.Special;
        }
    }

    ListView{
        id:lstView
        anchors.top : filterMenu.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 5
        width : parent.width
        spacing : 5
        model : globals.stuffModel
        clip : lstView
        snapMode : ListView.SnapToItem

        property int widthCol : (width - 5 * spacing) / 11
        delegate:Rectangle{
            color:"grey"
            opacity:0.7
            height: visible ? lstView.height *0.15 : 0
            width : parent.width
            visible : stuffPanel.currentTypeFilter==-1 || type == stuffPanel.currentTypeFilter
            Row{
               height:parent.height
               width : parent.width
               spacing: lstView.spacing
               Item{
                   height: parent.height
                   width: lstView.widthCol
                   Rectangle{
                       id:selectFrame
                       border.color: "yellow"
                       border.width: 1
                       radius : 3
                       visible : selected
                       anchors.fill: parent

                   }
                   Image{
                       id:stuffImage
                       source:model.image
                       anchors.fill: selectFrame
                       anchors.margins: 2
                       fillMode : Image.PreserveAspectFit
                   }

               }
               Column{
                   height: parent.height
                   width: lstView.widthCol * 3

                   Text{
                       text : qsTr(label) + "( x " + quantity + " )"
                       width : parent.width
                       height: parent.height
                       horizontalAlignment: Text.AlignHCenter
                       verticalAlignment : Text.AlignVCenter
                       font.pixelSize: globals.ui.textXL
                       color: globals.ui.textcolor
                       minimumPixelSize: globals.ui.minimumPixelSize
                       fontSizeMode : Text.Fit
                   }
               }
               Text{
                   text : qsTr(description)
                   width : lstView.widthCol * 4
                   height: parent.height
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment : Text.AlignVCenter
                   font.pixelSize: globals.ui.textS
                   color: globals.ui.textcolor
                   minimumPixelSize: globals.ui.minimumPixelSize
                   fontSizeMode : Text.Fit
               }

               SPSButtonText{
                   text:selected ? qsTr("unselect") : qsTr("select")
                   opacity: enabled ? 1 : 0
                   enabled : selectable && (quantity > 0)
                   height:parent.height
                   width : lstView.widthCol
                   onClicked: {
                       globals.stuffModel.setProperty(index, "selected", !selected);
                       EquipmentAction.useObject(idAction, selected, customProperties);
                   }
               }
               SPSButtonText{
                   text:"Use"
                   opacity: enabled ? 1 : 0
                   enabled : (useQuantity <= quantity) && (useQuantity > 0)
                   height:parent.height
                   width : lstView.widthCol
                   onClicked: {
                       globals.stuffModel.setProperty(index, "quantity", quantity-useQuantity);
                       EquipmentAction.useObject(idAction, true, customProperties);
                   }
               }
               SPSButtonText{
                   text:qsTr("Buy <br>(cost %1 $)").arg(cost)
                   opacity: enabled ? 1 : 0
                   height:parent.height
                   width : lstView.widthCol
                   enabled : (cost > 0) && (globals.perso.credits >= cost)
                   onClicked: {
                       globals.perso.credits -= cost;
                       globals.stuffModel.setProperty(index, "quantity", quantity+1);

                   }
               }

            }
        }
    }
/*
    ListModel{
        id:stuffModel
        //A dummy model to test the component
        ListElement{
            idAction: 1
            label:qsTr("gun ammo pack")
            image:"qrc:/res/bullet.png"
            cost: 50
            type : 2
            quantity : 1
            useQuantity : 1
            description : qsTr("A box of 10 bullets for the handgun")
            customProperties: [ ListElement{ ammo:10}]
            selectable:false
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 2
            label:qsTr("Shootgun ammo pack")
            image:"qrc:/res/ammo_shootgun.png"
            description : qsTr("A box of 5 bullets for the shotgun")
            cost: 100
            type : 2
            quantity : 1
            useQuantity : 1
            customProperties: [ ListElement{ ammo:5}]
            selectable:false
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 3
            label:qsTr("Riffle ammo pack")
            image:"qrc:/res/ammo_riffle.png"
            description : qsTr("A box of 10 bullets for the riffle")
            cost: 100
            type : 2
            quantity : 1
            useQuantity : 1
            customProperties: [ ListElement{ ammo:10}]
            selectable:false
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 4
            label:qsTr("gun")
            image:"qrc:/res/gun.png"
            description : qsTr("standard handgun")
            cost: 0
            type : 1
            quantity : 1
            useQuantity : 0
            customProperties: []
            selectable:true
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 5
            label:qsTr("Shotgun")
            image:"qrc:/res/shotgun.png"
            description : qsTr("A standard shootgun<br>Much easier to shoot, reduced range but higher damage")
            cost: 1000
            type : 1
            quantity : 0
            useQuantity : 0
            customProperties: []
            selectable:true
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 6
            label:qsTr("missile")
            image:"qrc:/res/missile.png"
            description : qsTr("No range limit, very high damage...the ultimate weapon (except if you have friends in the area)")
            cost: 5000
            type : 1
            quantity : 0
            useQuantity : 0
            customProperties: []
            selectable:true
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 7
            label:qsTr("medikit")
            image:"qrc:/res/medikit.png"
            description : qsTr("A very handy item...")
            cost: 50
            type : 3
            quantity : 1
            useQuantity : 1
            customProperties: [ ListElement{ health:20}]
            selectable:false
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
        ListElement{
            idAction: 8
            label:qsTr("Portal to Nantes")
            image:"qrc:/res/portal.png"
            description : qsTr("When selected your position will be ofsetted to Nantes center...")
            cost: 1
            type : 10
            quantity : 1
            useQuantity : 0
            customProperties: [ ListElement{ latitude:47.218908; longitude: -1.553766 } ]
            selectable:true
            selected: false
            health:100
            maxHealth:100
            useHealth:0
        }
    }
    */
}

