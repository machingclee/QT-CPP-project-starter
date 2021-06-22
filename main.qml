import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12


ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Project Starter")
    font.capitalization: Font.MixedCase

    Item{
        id: globalStates
        property string selectedProjectName: ""
        property int topPadding: 15
        property string selectedProjectUuid: ""
    }

    Item{
        id: globalActions

        signal showAlert(string message)
        signal navToProjectDetail()
        signal navToProjectList()
        signal setSelectedProjectUuid(string uuid)
        signal setSelectedProjectName(string projectName)

        onShowAlert: {
            confirmationPopup.message = message
            confirmationPopup.open()
        }
        onNavToProjectList: {
            stackView.push("qrc:/ProjectHomePage/ProjectsHome.ui.qml")
        }

        onNavToProjectDetail: {
            if(!globalStates.selectedProjectUuid){
                globalActions.showAlert("Please select a project in project list.")
            }else{
                stackView.push("qrc:/ProjectDetailPage/ProjectDetailForm.ui.qml")
            }
        }
        onSetSelectedProjectUuid: {
            globalStates.selectedProjectUuid = uuid
        }
        onSetSelectedProjectName: {
            globalStates.selectedProjectName = projectName
        }
    }

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text:  "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                drawer.open()
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.66
        height: window.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("Project List")
                width: parent.width
                onClicked: {
                    globalActions.navToProjectList()
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Project Detail")
                width: parent.width
                onClicked: {
                    globalActions.navToProjectDetail()
                    drawer.close()
                }
            }
        }
    }

    Popup{
        id: confirmationPopup
        padding: 20
        modal: true
        focus: true
        anchors.centerIn: parent
        property alias message:confirmationPopupMessage.text

        Column{
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            Label{
                id: confirmationPopupMessage

                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle{
                width:10
                height:10
            }

            Button{
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Ok"
                onClicked: {
                    confirmationPopup.close()
                }

            }
        }
    }



    StackView {
        id: stackView
        initialItem: "qrc:/ProjectHomePage/ProjectsHome.ui.qml"
        anchors.fill: parent
    }
}
