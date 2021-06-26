import QtQuick 2.12
import QtQuick.LocalStorage 2.12


Item {
    id: root
    property string dbName :"ProjectList"
    property string dbVersion :"1.0"
    property string dbDescription :"Store Project List"
    property int dbEstimatedSize : 1000000
    function getDb(){
        const db = LocalStorage.openDatabaseSync(dbName,
                                                 dbVersion,
                                                 dbDescription,
                                                 dbEstimatedSize)
        db.transaction(tx=>tx.executeSql('CREATE TABLE IF NOT EXISTS ProjectList(uuid TEXT, projectName TEXT)'))
        return db
    }


    function getAll(){
        const resultJson = []
        try{
            const db = root.getDb()
            db.transaction(function(tx){

                const result = tx.executeSql('SELECT * FROM ProjectList');
                const rows = result.rows
                for(var i=0; i<rows.length; i++){
                    const {uuid, projectName} = rows.item(i)
                    resultJson.push({ uuid, projectName })
                }
            })
            return { success: true, result: resultJson }
        }catch(err){
            return { success: false, err }
        }

    }

    function saveAll(listModel){
        try{
            const db = root.getDb()
            db.transaction(function(tx){
                for (var i=0;i< listModel.count; i++){
                    const { uuid, projectName } = listModel.get(i)
                    tx.executeSql('INSERT INTO ProjectList VALUES(?, ?)', [uuid, projectName]);
                }
            })

            return { success: true }
        }
        catch(err){
            return { success: false, err }
        }
    }

    function clearAll(){
        const db = root.getDb()
        try{
            db.transaction(function(tx){
                tx.executeSql('DELETE FROM ProjectList ')
            })
            return { success: true }
        }catch(err){
            return { success: false, err }
        }
    }
}
