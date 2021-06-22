import QtQuick 2.12
import QtQuick.Controls 2.12

Page {
    id: root
    width: 600
    height: 400
    title: qsTr("Project Detail - " + "<b><i>" + globalStates.selectedProjectName + "</i></b>")

    anchors.fill: parent

    DirCmdListComponent {}
}
