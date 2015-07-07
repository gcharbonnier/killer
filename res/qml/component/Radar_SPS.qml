
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtSensors 5.4


Item {

    ListModel{
        id:dummyModel
        ListElement {
            IdPlayer: 1
            Distance: 50
            Azimuth: 0
            Bearing: 0
            Type: 1
        }
        ListElement {
            IdPlayer: 2
            Distance: 100
            Azimuth: 90
            Bearing: 0
            Type: 1
        }
        ListElement {
            IdPlayer: 3
            Distance: 150
            Azimuth: 180
            Bearing: 0
            Type: 1
        }
        ListElement {
            IdPlayer: 4
            Distance: 200
            Azimuth: 270
            Bearing: 0
            Type: 1
        }
    }

    id:radar
    property real heading: 0.0
    property bool showCompass: true
    property bool showZoomControl: true
    property real maxRange: 200.0
    property var model: dummyModel
    property var delegate: defaultDelegate

    Rectangle{
        id:background

        width:  height
        height: parent.height < parent.width ? parent.height : parent.width
        radius: width/2
        color:"darkgreen"
        border.width:10
        border.color:"white"
        opacity:0.5

        Item{
            width: parent.width
            height: width
            Image{
                anchors.fill: parent
                source:"qrc:/res/compass.png"
                visible: showCompass

            }
            rotation : heading
            transformOrigin: Item.Center
        }

        Rectangle{
            id:radarline
            width:background.width/2 -10
            height:50
            radius:10
            transformOrigin: Item.TopLeft
            x: parent.x + parent.width/2
            y: parent.y + parent.height/2
            gradient: Gradient{
                 GradientStop { position: 0.0; color: "white" }
                 GradientStop { position: 0.1; color: "white" }
                 GradientStop { position: 0.2; color: "#88FFFFFF" }
                 GradientStop { position: 1.0; color: "#00FFFFFF" }
            }
            RotationAnimation  on rotation{
                loops:Animation.Infinite
                from: 360
                to: 0
                running:true
                duration:5000
            }
        }

        Repeater{
            id:scales
            model:5
            Rectangle{
                anchors.centerIn: parent
                border.color: "white"
                border.width: 1
                width: background.width * index / scales.count
                height:width
                radius:width/2
                color:"#00FFFFFF"
                Text{
                    color:"white"
                    text: maxRange * index / scales.count + "m"
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

        }
    }

    Component{
        id:defaultDelegate
        Rectangle{
            height:32
            width:32
            radius:16
            color:model.Type === 1 ? "red" : "green"
            x: ( 1 + Math.cos( (-model.Azimuth -heading  + 90 ) / 180. * Math.PI) * ( Math.min( model.Distance, maxRange ) / maxRange) ) * (background.width/2) - width/2
            y: ( 1 - Math.sin( (-model.Azimuth -heading  + 90 ) / 180. * Math.PI) * ( Math.min( model.Distance, maxRange ) / maxRange) ) * (background.height/2) - height/2

            Text{
                text: model.IdPlayer
                anchors.centerIn : parent
            }

            Item{
                id:infoTip
                anchors.centerIn: parent
                visible: false
                Column{
                    Text{
                        text:"Azimuth:" +  model.Azimuth + "°"
                    }
                    Text{
                        text:"Distance:" +  model.Distance + "m"
                    }
                }
            }

            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    infoTip.visible = !infoTip.visible
                }
            }
        }
    }


    Repeater{
        id:lstView
        //model:  dummyModel
        model:  radar.model
        delegate: radar.delegate

    }

    Item{
        visible: showZoomControl
        anchors.bottom : parent.bottom
        width: parent.width
        height:100
        Rectangle{
            height: 100
            width:100
            color: globals.ui.buttonBkColor
            radius: 30
            anchors.left: parent.left
            Text{
                anchors.centerIn: parent
                text:"-"
                font.pixelSize: globals.ui.textXXXL
                color: globals.ui.textcolor

            }
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    if (maxRange>50)
                        maxRange=maxRange-50;
                    mouse.accepted=false;
                }
            }
        }
        Text{
            anchors.centerIn: parent
            text:"Max Range : "+maxRange+" m"
            font.pixelSize: globals.ui.textM
            color: globals.ui.textcolor

        }
        Rectangle{
            height: 100
            width:100
            color: globals.ui.buttonBkColor
            radius: 30
            anchors.right: parent.right
            Text{
                anchors.centerIn: parent
                text:"+"
                font.pixelSize: globals.ui.textXXXL
                color: globals.ui.textcolor


            }
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                   maxRange=maxRange+50;
                    mouse.accepted=false;
                }

            }
        }
    }
}
