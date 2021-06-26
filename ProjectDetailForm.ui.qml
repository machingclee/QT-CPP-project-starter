import QtQuick 2.2
import QtQuick.Controls 2.2
Page {
    id: root
    width: 600
    height: 400
    title: qsTr("Project Detail - " + "<b><i>" + globalStates.selectedProjectName + "</i></b>")

    anchors.fill: parent

    DirCmdListComponent {}
}
