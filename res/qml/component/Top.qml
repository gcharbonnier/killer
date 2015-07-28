import QtQuick 2.0

Item {

    Row{
        spacing: 3
        anchors.fill: parent
        anchors.margins: 3

        property int colWidth : (width - menuSelector.width - 3 * spacing) / 4

        Column{
            height : parent.height
            width : parent.colWidth
            spacing: 5
            SPSButtonText{
                text : accountModel.accountName
                //text: "Charby"
                color:"transparent"
                width: parent.width
                height: parent.height * 0.45

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        //content.stack.push({item:Qt.resolvedUrl("qrc:/res/qml/component/Player.qml"), replace:true});
                        content.stack.push({item:Qt.resolvedUrl("qrc:/res/qml/component/HallOfFame.qml"), replace:true});
                    }
                }
            }
            SPSButtonText{
                text: gameManager.campaignName
                color:"transparent"
                width: parent.width
                height: parent.height * 0.45

                MouseArea{
                    anchors.fill: parent          
                    onClicked: {
                        content.stack.push({item:Qt.resolvedUrl("qrc:/res/qml/component/Campaign.qml"), replace:true});
                    }
                }
            }
        }

        Column{
            height : parent.height
            width : parent.colWidth * 3
            spacing: 5

            SPSProgressBar{
                width: parent.width
                height: parent.height * 0.45
                sourceSymbol: "qrc:/res/appbar.cards.heart.png"
                value: globals.perso.health
                minValue : 0
                maxValue: globals.perso.maxHealth
            }
            Row{
                width: parent.width
                height: parent.height * 0.45
                spacing : 5
                SPSProgressBar{
                    width: parent.width * 0.45
                    height: parent.height
                    showAsPerc : false
                    minValue : globals.perso.xpMinLevelCurrent
                    maxValue: globals.perso.xpMaxLevelCurrent
                    prefixText : qsTr("Level %1 - XP: ").arg( globals.perso.level)
                    value: globals.perso.xp
                }

                SPSButtonText{
                    id:creditsText
                    text: "$ : " + globals.perso.credits
                    width: Math.min( 200 ,parent.width)
                    color: globals.ui.buttonBkColor
                    height: parent.height
                }

                SPSProgressBar{
                    prefixText: qsTr("Energy : ")
                    value: globals.perso.energy
                    showAsPerc : false
                    minValue: 0
                    maxValue: globals.perso.maxEnergy
                    width: parent.width * 0.5 - creditsText.width
                    //color: globals.ui.buttonBkColor
                    height: parent.height
                }

            }
        }


        //Reseau
        //Connexion bdd



    }

    MenuSelector{
        id:menuSelector
        maximizedWidth: mainWnd.width / 2
        maximizedheight: mainWnd.height
        width: height
        height: parent.height
        anchors{
            right: parent.right
            top: parent.top
        }
        model: ListModel{
            id:menuContent
            ListElement {
                imageSource: "qrc:/res/crosshairs-146113_640.png"
                componentUrl: "qrc:/res/qml/component/Map.qml"
                label: qsTr("Map")
            }
            /*
            ListElement {
                imageSource: "qrc:/res/fingerprint48.png"
                componentUrl: "qrc:/res/qml/component/Character.qml"
                label: qsTr("Character")
            }
            */
            ListElement {
                imageSource: "qrc:/res/reading-310397_640.png"
                componentUrl: "/res/qml/component/Help.qml"
                label: qsTr("Help")
            }
            ListElement {
                imageSource: "qrc:/res/star139.png"
                componentUrl: "/res/qml/component/Rewards.qml"
                label: qsTr("Rewards")
            }

            ListElement {
                imageSource: "qrc:/res/walkie5.png"
                componentUrl: "/res/qml/component/Intercom.qml"
                label: qsTr("Intercom")
            }

            /*
            ListElement {
                imageSource: "qrc:/res/man374.png"
                componentUrl: "/res/qml/component/Skills.qml"
                label: qsTr("Skills")
            }
            */

            ListElement {
                imageSource: "qrc:/res/shield77.png"
                componentUrl: "/res/qml/component/Equipment.qml"
                label: qsTr("Equipment")
            }
        }
        stack: content.stack

    }








}

