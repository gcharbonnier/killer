import QtQuick 2.0
import QtLocation 5.3
import QtPositioning 5.0
//import QtQuick.XmlListModel 2.0
//http://qt.developpez.com/doc/5.0-snapshot/declarative-mapviewer-content-map-mapcomponent-qml/

Item {
    id:myMap
    //anchors.fill: parent
    property alias model: mapItemView.model
    property alias zoomLevel: map.zoomLevel
    //property var delegate: defaultDelegate

    /*Plugin{
        id:mapPlugin
        name: "osm"
        PluginParameter { name: "osm.useragent"; value: "Killer urban game Qt OSM application" }
        //PluginParameter { name: "osm.mapping.host"; value: "http://osm.tile.server.address/" }
        //PluginParameter { name: "osm.mapping.copyright"; value: "All mine" }
        //PluginParameter { name: "osm.routing.host"; value: "http://osrm.server.address/viaroute" }
        //PluginParameter { name: "osm.geocoding.host"; value: "http://geocoding.server.address" }
    }*/
    Plugin{
        id:mapPlugin
        name: "mapbox"
        PluginParameter { name: "useragent"; value: "Killer urban game Qt OSM application" }
        PluginParameter { name: "mapbox.access_token"; value: "pk.eyJ1IjoiY2hhcmJ5IiwiYSI6Ijc0ZTc1NjA5YjhlZTJiNGU1NzQ2OWFiYjNlYmYxMGNiIn0.mtjd_F2G1M81vCULJWzhGQ" }
        PluginParameter { name: "mapbox.map_id"; value: "mapbox.pencil"  }//"wheatpaste/comic/pencil/dark"
    }

    Map {
       id: map
       anchors.fill: mapFrame
       anchors.margins: mapFrame.border.width//Math.min(20, myMap.height*0.1)
       plugin: mapPlugin
       center: mainWnd.isDev ? QtPositioning.coordinate(47.096207, -1.636881) : gameManager.lastPosition//posSource.position.coordinate//QtPositioning.coordinate(47.096207, -1.636881)
       zoomLevel: map.maximumZoomLevel
       gesture.enabled: mainWnd.isDev


       gesture.onPanFinished: {
           gameManager.simulateGPS(center);

       }

       /*
       onCenterChanged:{
           if (mainWnd.isDev)
                gameManager.simulateGPS(center);


       }*/



       MapItemView{
           id:mivEnergy
           model: geoLocalItemsModel



           delegate: MapQuickItem {
              //anchorPoint:
              id:delegateMQI2
              coordinate: QtPositioning.coordinate(Latitude,Longitude)


              sourceItem:  Image{
                  source: model.Type === 0 ? "qrc:/res/energy.png" : model.Type === 1 ? "qrc:/res/medikit.png" :  "qrc:/res/work.png"
                  width: Math.min( 50, Math.max(5, 32 / 50 * model.Value))
                  height:width
                  //radius:16
                  opacity: 0.6
                  //color:"blue"
            }
                  /*ShaderEffectSource {
                      id: theSource
                      sourceItem: model.Type === 0 ? energydelegate : model.Type === 1 ? healthdelegate : creditsdelegate
                      hideSource: true
                      opacity: 0.6

                      ShaderEffect {
                          width: Math.max(10, 32 / 50 * model.Energy) //energydelegate.width
                          height: width//energydelegate.height
                          //x:energydelegate.x
                          //y:energydelegate.y

                          property variant source: theSource
                          property real amplitude: 0.025
                          property real frequency: 10
                          property real time: 0
                          NumberAnimation on time { loops: Animation.Infinite; from: 0; to: Math.PI * 2; duration: 600 }
                          //! [fragment]
                          fragmentShader:
                              "uniform lowp float qt_Opacity;" +
                              "uniform highp float amplitude;" +
                              "uniform highp float frequency;" +
                              "uniform highp float time;" +
                              "uniform sampler2D source;" +
                              "varying highp vec2 qt_TexCoord0;" +
                              "void main() {" +
                              "    highp vec2 p = sin(time + frequency * qt_TexCoord0);" +
                              "    gl_FragColor = texture2D(source, qt_TexCoord0 + amplitude * vec2(p.y, -p.x)) * qt_Opacity;" +
                              "}"
                          //! [fragment]
                  }

             }*/


          }

       }

       MapItemView{
           id:mapItemView
           model: dummyModel          

           delegate: MapQuickItem {
              //anchorPoint:
              id:delegateMQI
              coordinate: QtPositioning.coordinate(Latitude,Longitude)
              sourceItem: Rectangle{
                  id:defaultDelegate
                  width:50
                  height:50
                  radius:5
                  //opacity: 0.6
                  border.width: 2
                  rotation: 0//model.Azimuth
                  //border.color: "grey"
                  //color:IdPlayer == globals.currentTarget.id ? "yellow" :(Type === 1 ? "red" : "green")//(IdPlayer == globals.currentTarget.id) ? "yellow" :(Type === 1 ? "red" : "green")
                  border.color: IdPlayer == globals.currentTarget.id ? "yellow" :(Type === 1 ? "red" : "green")//(IdPlayer == globals.currentTarget.id) ? "yellow" :(Type === 1 ? "red" : "green")
                  color:"transparent"

                  Image{
                      anchors.fill: parent
                      anchors.margins: 5
                      source : "qrc:/res/background_character.png"
                      fillMode: Image.PreserveAspectFit
                  }
                  Text{
                      text: NamePlayer
                      width : parent.width
                      height : parent.height
                      font.pixelSize: globals.ui.textXL
                      minimumPixelSize: 5
                      color:"grey"
                      fontSizeMode : Text.Fit
                      font.family: "Syncopate"
                      horizontalAlignment: Text.AlignHCenter
                      verticalAlignment : Text.AlignVCenter
                  }


                  Item{
                      id:infoTip
                      anchors.centerIn: parent
                      visible: false
                      //rotation:-model.Azimuth
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
                          infoTip.visible = !infoTip.visible;
                          mouse.accepted = false;
                          globals.currentTarget.modelIndex = index;

                      }
                  }

              }

          }

       }
    }


    Rectangle{
        id:mapFrame
        anchors.fill : parent
        anchors.margins : 5
        radius : 2 * border.width
        border.color: "darkgrey"
        border.width: Math.min( 10, parent.height * 0.01)
        color: "transparent"
        clip: true
        z:10

        Rectangle{
            width : mapFrame.width * 0.10
            height : width
            opacity : 0.7
            anchors.left : parent.left
            anchors.top : parent.top
            anchors.margins : mapFrame.border.width
            color : "lightgrey"
            border.width: 1
            border.color: "black"
            radius : 5
            z:-1
            Image{
                anchors.fill: parent
                source : "qrc:/res/appbar.magnify.minus.png"
                fillMode: Image.PreserveAspectFit
            }
            MouseArea{
                anchors.fill: parent
                onClicked: map.zoomLevel--
            }
        }
        Rectangle{
            width : mapFrame.width * 0.10
            height : width
            opacity : 0.7
            anchors.right : parent.right
            anchors.top : parent.top
            anchors.margins : mapFrame.border.width
            color : "lightgrey"
            border.width: 1
            border.color: "black"
            radius : 5
            z:-1
            Image{
                anchors.fill: parent
                source : "qrc:/res/appbar.magnify.add.png"
                fillMode: Image.PreserveAspectFit
            }
            MouseArea{
                anchors.fill: parent
                onClicked: map.zoomLevel++
            }
        }



        Image{
            id:leftHandle
            //original dimensions : 541x720, folded area : 219x215
            property int foldedAreaWidth : 219 / 541 * width
            property int foldedAreaHeight : 215 / 720 * height
            height : width
            width : mapFrame.width * 0.3
            opacity:1
            x: mapFrame.x + foldedAreaWidth - width
            y: mapFrame.y + mapFrame.height - 2*mapFrame.border.width - foldedAreaHeight
            z:-1
            //color:"transparent"
            state : "closed"
            source : "qrc:/res/leftHandle.png"

            Text{
                id: labelLeftHandle
                text: qsTr("Map info")
                y:leftHandle.foldedAreaHeight * 0.2
                x:leftHandle.width - leftHandle.foldedAreaWidth
                //anchors.top : parent.top
                //anchors.right : parent.right
                width: leftHandle.foldedAreaWidth * 0.8
                height: leftHandle.foldedAreaHeight * 0.8
                rotation: Math.atan( leftHandle.foldedAreaHeight / leftHandle.foldedAreaWidth ) / Math.PI * 180
                color: "black"
                font.pixelSize: globals.ui.textGodzilla
                minimumPixelSize: globals.ui.minimumPixelSize
                fontSizeMode : Text.Fit
                font.family: "Sawasdee"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment : Text.AlignVCenter

            }

            Grid{
                anchors.top: labelLeftHandle.bottom
                anchors.bottom : parent.bottom
                anchors.left : parent.left
                anchors.right: parent.right
                anchors.margins: 5
                columns:2
                rows: 3
                property int rowHeight : height / 3

                Text{
                    text: "Current target"
                    width: parent.width - parent.rowHeight
                    height: parent.rowHeight
                    color: globals.ui.textcolor
                    font.pixelSize:globals.ui.textGodzilla
                    minimumPixelSize: globals.ui.minimumPixelSize
                    fontSizeMode : Text.Fit
                    font.family: "Sawasdee"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment : Text.AlignVCenter

                }
                Rectangle{
                                  width:parent.rowHeight
                                  height:parent.rowHeight
                                  radius:parent.rowHeight * 0.5
                                  opacity: 0.6
                                  border.width: 3
                                  border.color: "grey"
                                  color:"yellow"
                }
                Text{
                    text: "Friends"
                    width: parent.width - parent.rowHeight
                    height: parent.rowHeight
                    color: globals.ui.textcolor
                    font.pixelSize:globals.ui.textGodzilla
                    minimumPixelSize: globals.ui.minimumPixelSize
                    fontSizeMode : Text.Fit
                    font.family: "Sawasdee"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment : Text.AlignVCenter

                }
                Rectangle{
                                  width:parent.rowHeight
                                  height:parent.rowHeight
                                  radius:parent.rowHeight * 0.5
                                  opacity: 0.6
                                  border.width: 3
                                  border.color: "grey"
                                  color:"green"
                }
                Text{
                    text: qsTr("Ennemies")
                    width: parent.width - parent.rowHeight
                    height: parent.rowHeight
                    color: globals.ui.textcolor
                    font.pixelSize:globals.ui.textGodzilla
                    minimumPixelSize: globals.ui.minimumPixelSize
                    fontSizeMode : Text.Fit
                    font.family: "Sawasdee"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment : Text.AlignVCenter

                }
                Rectangle{
                                  width:parent.rowHeight
                                  height:parent.rowHeight
                                  radius:parent.rowHeight * 0.5
                                  opacity: 0.6
                                  border.width: 3
                                  border.color: "grey"
                                  color: "red"
                }


            }

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
                PropertyChanges { target:labelLeftHandle; rotation : 0 ; x : 0 ; width: (leftHandle.width - leftHandle.foldedAreaWidth) *0.8}
            }

            transitions: Transition {
                PropertyAnimation { properties: "x, y, height, rotation"; duration:1000;easing.type: Easing.InOutQuad }
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
            x: mapFrame.x + mapFrame.width - mapFrame.radius - foldedAreaWidth
            y: mapFrame.y + mapFrame.height - mapFrame.radius - foldedAreaHeight
            z:-1
            //color:"transparent"
            state : "closed"
            source : "qrc:/res/rightHandle.png"

            Text{
                id: labelRightHandle
                text: qsTr("Target info")
                y:0//rightHandle.foldedAreaHeight * 0.5
                x:0
                width: rightHandle.foldedAreaWidth
                height: rightHandle.foldedAreaHeight
                rotation: -Math.atan( rightHandle.foldedAreaHeight / rightHandle.foldedAreaWidth ) / Math.PI * 180
                color: "black"
                font.pixelSize: globals.ui.textGodzilla
                minimumPixelSize: globals.ui.minimumPixelSize
                fontSizeMode : Text.Fit
                font.family: "Sawasdee"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment : Text.AlignVCenter

            }

            Column{
                anchors.top: labelRightHandle.bottom
                anchors.bottom : parent.bottom
                anchors.left : parent.left
                anchors.right: parent.right
                anchors.margins: 5
                property int rowHeight : height / 3
                Text{
                    text: qsTr("Heading : %1°").arg( globals.currentTarget.azimuth)

                    width: parent.width
                    height: parent.rowHeight

                    color: globals.ui.textcolor
                    font.pixelSize: globals.ui.textGodzilla
                    minimumPixelSize: globals.ui.minimumPixelSize
                    fontSizeMode : Text.Fit
                    font.family: "Sawasdee"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter

                }
                Text{
                    text: qsTr("Distance : %1m").arg(globals.currentTarget.distance)

                    width: parent.width
                    height: parent.rowHeight

                    color: globals.ui.textcolor
                    font.pixelSize: globals.ui.textGodzilla
                    minimumPixelSize: globals.ui.minimumPixelSize
                    fontSizeMode : Text.Fit
                    font.family: "Sawasdee"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter
                }
                SPSProgressBar{
                    prefixText: qsTr("Health : ")
                    value: globals.currentTarget.health
                    sourceSymbol: "qrc:/res/appbar.cards.heart.png"
                    width: parent.width
                    height: parent.rowHeight
                }

            }

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
                PropertyChanges { target:labelRightHandle; text: globals.currentTarget.name; rotation : 0 ; x : rightHandle.foldedAreaWidth ; width: (rightHandle.width - rightHandle.foldedAreaWidth) *0.8}
            }

            transitions: Transition {
                PropertyAnimation { properties: "x, y, height, width, rotation"; duration:1000;easing.type: Easing.InOutQuad }
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
