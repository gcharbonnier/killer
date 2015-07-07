import QtQuick 2.0
import QtLocation 5.4
import QtPositioning 5.4
//import QtQuick.XmlListModel 2.0
//http://qt.developpez.com/doc/5.0-snapshot/declarative-mapviewer-content-map-mapcomponent-qml/

Item {
    id:myMap
    //anchors.fill: parent
    property var center: QtPositioning.coordinate(47.0964, -1.6368)
    property alias model: mapItemView.model
    property alias zoomLevel: map.zoomLevel
    //property var delegate: defaultDelegate

    Map {
       id: map
       anchors.fill: parent
       anchors.margins: 20
       plugin:  Plugin { name: "osm"}
       center: myMap.center
       zoomLevel: map.maximumZoomLevel

       MapItemView{
           id:mapItemView
           model: dummyModel


           delegate: MapQuickItem {
              //anchorPoint:
              id:delegateMQI
              sourceItem: Rectangle{
                  id:defaultDelegate
                  width:32
                  height:32
                  radius:16
                  opacity: 0.6
                  color:
                      (IdPlayer == globals.currentTarget.id) ? "yellow" :(Type === 1 ? "red" : "green")

                  Text{
                      text: NamePlayer
                      anchors.centerIn : parent
                  }

                  Item{
                      id:infoTip
                      anchors.centerIn: parent
                      visible: false
                      Column{
                          Text{
                              text:"Azimuth:" +  Azimuth + "°"
                          }
                          Text{
                              text:"Distance:" +  Distance + "m"
                          }
                      }
                  }

                  MouseArea{
                      anchors.fill: parent
                      propagateComposedEvents: true
                      onClicked: {
                          infoTip.visible = !infoTip.visible
                          mouse.accepted = false
                      }
                  }

              }
              coordinate: QtPositioning.coordinate(Latitude,Longitude)
          }

       }
    }

    Rectangle{
        id:mapFrame
        anchors.fill : parent
        anchors.margins : 10
        radius : 30
        border.color: "darkgrey"
        border.width: 10
        color: "transparent"
        clip: true
        z:10

        Image{
            id:leftHandle
            //original dimensions : 541x720, folded area : 219x215
            property int foldedAreaWidth : 219 / 541 * width
            property int foldedAreaHeight : 215 / 720 * height
            height : width
            width : mapFrame.width * 0.3
            //opacity:0.7
            x: mapFrame.x + foldedAreaWidth - width
            y: mapFrame.y + mapFrame.height - 2*mapFrame.border.width - foldedAreaHeight
            z:-1
            //color:"transparent"
            state : "closed"
            source : "qrc:/res/leftHandle.png"


            Column{
                anchors.fill: parent
                Text{
                    text:"you"
                }
                Text{
                    text:"me"
                }
                Text{
                    text:"them"
                }
                Text{
                    text:"everybody"
                }
            }
            /*Image{
                id:handleImg
                height: parent.height * 0.3
                width : height
                anchors.top : parent.top
                anchors.right : parent.right
                source : "qrc:/res/handleRight.png"

            }*/
            MouseArea{
                anchors.fill: parent
                preventStealing: true
                onClicked:{
                    if (parent.state == "closed") parent.state = "open";
                    else parent.state = "closed";

                }
            }
            states:
            State {
                name: "open"
                PropertyChanges { target:leftHandle; height: mapFrame.height * 0.3; x : mapFrame.x ; y: mapFrame.y + mapFrame.height - 2*mapFrame.border.width - height }
            }

            transitions: Transition {
                PropertyAnimation { properties: "x, y, height"; duration:1000;easing.type: Easing.InOutQuad }
            }
        }

        Image{
            id:rightHandle
            //original dimensions : 541x720, folded area : 219x215
            property int foldedAreaWidth : 219 / 541 * width
            property int foldedAreaHeight : 215 / 720 * height
            height : width
            width : mapFrame.width * 0.3
            //opacity:0.7
            x: mapFrame.x + mapFrame.width - 2*mapFrame.border.width - foldedAreaWidth
            y: mapFrame.y + mapFrame.height - 2*mapFrame.border.width - foldedAreaHeight
            z:-1
            //color:"transparent"
            state : "closed"
            source : "qrc:/res/rightHandle.png"


            Column{
                anchors.fill: parent
                anchors.margins: 10
                anchors.topMargin: parent.foldedAreaHeight + 10
                property int rowHeight : (height - anchors.margins - anchors.topMargin) / 3
                Text{
                    text: globals.currentTarget.name

                    width: parent.width
                    height: parent.rowHeight

                    color: globals.ui.textcolor
                    font.pixelSize: globals.ui.textGodzilla
                    minimumPixelSize: globals.ui.minimumPixelSize
                    fontSizeMode : Text.Fit
                    font.family: "Syncopate"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter

                }
                Text{
                    text: globals.currentTarget.distance + " m"

                    width: parent.width
                    height: parent.rowHeight

                    color: globals.ui.textcolor
                    font.pixelSize: globals.ui.textGodzilla
                    minimumPixelSize: globals.ui.minimumPixelSize
                    fontSizeMode : Text.Fit
                    font.family: "Syncopate"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter
                }

            }
            /*Image{
                id:handleImg
                height: parent.height * 0.3
                width : height
                anchors.top : parent.top
                anchors.right : parent.right
                source : "qrc:/res/handleRight.png"

            }*/
            MouseArea{
                anchors.fill: parent
                preventStealing: true
                onClicked:{
                    if (parent.state == "closed") parent.state = "open";
                    else parent.state = "closed";

                }
            }
            states:
            State {
                name: "open"
                PropertyChanges { target:rightHandle; height: mapFrame.height * 0.3; x : mapFrame.x + mapFrame.width + mapFrame.border.width - width ; y: mapFrame.y + mapFrame.height - 2*mapFrame.border.width - height }
            }

            transitions: Transition {
                PropertyAnimation { properties: "x, y, height"; duration:1000;easing.type: Easing.InOutQuad }
            }
        }

    }

    ListModel{
        id:dummyModel
        ListElement {
            Latitude: 47.1
            Longitude: -1.6
            IdPlayer: 2
            Distance: 112
            Azimuth: 0
            Type: 1
        }
        ListElement {
            Latitude: 47.2
            Longitude: -1.7
            IdPlayer: 1
            Distance: 28
            Azimuth: 0
            Type: 2
        }
        ListElement {
            Latitude: 47.0
            Longitude: -1.5
            IdPlayer: 3
            Distance: 50
            Azimuth: 0
            Type: 1
        }
        ListElement {
            Latitude: 47.3
            Longitude: -1.4
            IdPlayer: 4
            Distance: 50
            Azimuth: 0
            Type: 1
        }

    }

/*
    XmlListModel
        {
            id: geocodeModelXml
            source: "https://www.capitalbikeshare.com/data/stations/bikeStations.xml"
            query: "/stations/station"
            XmlRole { name: "latitude"; query: "lat/string()"; isKey: true }
            XmlRole { name: "longitude"; query: "long/string()"; isKey: true }
        }
*/





}
