import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.0
import com.company.backend 1.0

//database is stored in C:\Users\user\AppData\Local\project-starter\QML\OfflineStorage\Databases

Item {
    id: root
    anchors.fill: parent

    Item{
        id: states
        property int selectedIndex: 0
        property variant projectListModel: ListModel {}
    }

    Backend {
        id: backend
    }

    Component.onCompleted:{
        actions.getAllProjects()
    }


    ProjectDetailDAO{
        id: projectDetailDAO
    }


    Item{
        id: actions
        signal addProjectListAndCommand()
        signal folderPathIsChosen(string selectedDirPath)
        signal projectDirIndexSelected(int currIndex)
        signal saveClicked()
        signal getAllProjects()
        signal clearAllProjects()
        signal executeAll()
        signal removeAtIndex(int index)
        signal changePropertyAtIndex(int index, string property_, variant value)


        onProjectDirIndexSelected: {
            states.selectedIndex = currIndex
        }
        onAddProjectListAndCommand: {
            const uuid = globalStates.selectedProjectUuid
            states.projectListModel.append({projectDir:"", projectInitCommand:"", uuid })
        }
        onFolderPathIsChosen: {
            const targetRow = states.projectListModel.get(states.selectedIndex)
            targetRow.projectDir = selectedDirPath
            states.projectListModel.set(states.selectedIndex, targetRow)
        }
        onSaveClicked: {
            const uuid = globalStates.selectedProjectUuid
            projectDetailDAO.clearProjectDetailList(uuid)
            const {success, error} = projectDetailDAO.saveProjectList(states.projectListModel)

            if(error){
                globalActions.showAlert(error);
            } else {
                globalActions.showAlert("Project datail is successfully saved.")
            }
        }

        onGetAllProjects: {
            const uuid = globalStates.selectedProjectUuid
            const {result: projectList, err} = projectDetailDAO.getProjectList(uuid)
            if(err){
                globalActions.showAlert(err);
            } else {
                states.projectListModel.clear()
                const length = projectList.length;
                for(var i=0; i<length; i++){
                    states.projectListModel.append(projectList[i])
                }
            }
        }
        onClearAllProjects: {
            projectDetailDAO.clearProjectDetailList()
        }

        onExecuteAll: {
            const length = states.projectListModel.count
            const dirPaths = []
            const commands = []
            for (var i=0; i<length; i++){
                const dirPath = states.projectListModel.get(i).projectDir
                const command = states.projectListModel.get(i).projectInitCommand
                dirPaths.push(dirPath)
                commands.push(command)
            }

            const combinedCmds = []

            for (var i=0; i<length; i++){
                const dirPath = dirPaths[i]
                const cmd = commands[i]
                combinedCmds.push({dirPath, cmd})
            }

            backend.executeShellCommands(combinedCmds)
        }
        onRemoveAtIndex: {
            states.projectListModel.remove(index, 1)
        }
        onChangePropertyAtIndex: {
            states.projectListModel.setProperty(index, property_, value)
        }
    }






    FolderDialog{
        id: folderDialog
        onAccepted: {
            console.log("folderDialog.folder.toString()",folderDialog.folder.toString())
            const targetFolderPath = folderDialog.folder.toString().replace("file://","")
            actions.folderPathIsChosen(targetFolderPath)
        }
    }



    Column{
        id: column
        width: parent.width
        height:parent.height
        anchors.top: parent.top
        spacing: 10

        Rectangle {
            id: dummy
            width: 200
            height: 15
            color: "#ffffff"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            id: row
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 14

            Button{
                id: addProjectListButton
                text: "Add new project directory"
                width:200
                height:36
                onClicked: actions.addProjectListAndCommand()
            }

            Button {
                id: saveButton
                height: 36
                text: qsTr("Save")
                onClicked: {
                    actions.saveClicked()
                }
            }



            Button {
                id: executeButton
                height: 36
                text: qsTr("Execute")
                onClicked: {
                    actions.executeAll()
                }
            }
        }


        ScrollView{
            height: parent.height - addProjectListButton.height
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            ListView{
                id: projectDirCommandListView
                focus: true
                clip:true
                spacing: 10
                visible: true
                model: states.projectListModel
                delegate: projectDirRowDelegate
            }
        }
    }


    Component {
        id: projectDirRowDelegate

        Item{
            property int delegateIndex: index
            id:container
            height: 40
            width: parent.width

            Row {
                id: grid
                height: 40
                spacing: 9
                anchors.horizontalCenter: parent.horizontalCenter

                TextField {
                    id: projectDirTextField
                    text: projectDir || ""
                    readOnly: true
                    selectByMouse: true
                    placeholderText: qsTr("Project Directory")
                }

                Button{
                    text:"Choose Dir"
                    onClicked: {
                        folderDialog.open()
                        actions.projectDirIndexSelected(index)
                    }
                }

                TextField {
                    id: projectCommandTextField
                    text: projectInitCommand
                    selectByMouse: true
                    placeholderText: qsTr("Command")
                    onTextChanged: {
                        actions.changePropertyAtIndex(
                                    index,
                                    "projectInitCommand",
                                    projectCommandTextField.text)
                    }
                }

                Button{
                    id: deleteButton
                    text: "Del"
                    width: 40
                    onClicked: {
                        try{
                            actions.removeAtIndex(index)
                        } catch(err){
                            globalActions.showAlert(err)
                        }
                    }
                }

            }
        }
    }









}




/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.75;height:480;width:640}D{i:3}
}
##^##*/
