import java.sql.*

def  conA = DriverManager.getConnection("jdbc:hsqldb:hsql://localhost:9001/dbmaster", "sa", "");
def  conB = DriverManager.getConnection("jdbc:sqlserver://localhost\\SQL2017DEV;databaseName=DBM2;integratedSecurity=true", "", "");

/*
copyTable(conA , conB, "SCRIPT_VERSION");
copyTable(conA , conB, "CORE_VERSION");
copyTable(conA , conB, "CUSTOMFIELD_CONFIG");
copyTable(conA , conB, "CUSTOMFIELD_CONFIG_VALUES_TEXT", false);
copyTable(conA , conB, "CUSTOMFIELD_VALUE", false);
copyTable(conA , conB, "CUSTOMFIELD_CONFIG_DISPLAY");
copyTable(conA , conB, "PERMISSION");
copyTable(conA , conB, "PROJECT");
copyTable(conA , conB, "CORE_USER");
copyTable(conA , conB, "INV_JOB");
copyTable(conA , conB, "INV_APP_INSTANCE");
copyTable(conA , conB, "INV_APPLICATION");
copyTable(conA , conB, "INV_APPLICATION_LINK");
copyTable(conA , conB, "INV_CONTACT");
copyTable(conA , conB, "INV_CONTACT_LINK");
copyTable(conA , conB, "INV_DATABASE");
copyTable(conA , conB, "INV_DATABASE_USAGE");
copyTable(conA , conB, "INV_SERVER");
copyTable(conA , conB, "INV_SECURITY_OBJECT");
copyTable(conA , conB, "INV_SECURITY_OBJECT_LINK");
copyTable(conA , conB, "INV_EXTERNAL_LINK");
copyTable(conA , conB, "FOREIGNKEY_COLUMNS",false);
copyTable(conA , conB, "INDEX_COLUMNS",false);
copyTable(conA , conB, "DB_COLUMN");
copyTable(conA , conB, "DB_CONNECTION");
copyTable(conA , conB, "DB_CONSTRAINT");
copyTable(conA , conB, "DB_FOREIGN_KEY");
copyTable(conA , conB, "DB_INDEX");
copyTable(conA , conB, "DB_MODEL");
copyTable(conA , conB, "DB_MODEL_OBJECT");
copyTable(conA , conB, "COLLABORATION_TOPIC");
*/
copyTable(conA , conB, "ADHOC_REPORT_CONFIG");
copyTable(conA , conB, "DBM_FEED_ITEM");
copyTable(conA , conB, "UI_GRID_COLUMN_CONFIG");
copyTable(conA , conB, "DBM_SYNC_ATTRIBUTE");
copyTable(conA , conB, "DBM_SYNC_PAIR");
copyTable(conA , conB, "DBM_SYNC_SESSION");
copyTable(conA , conB, "DBM_FILE_REF");
copyTable(conA , conB, "DBM_TOOL_HISTORY");
copyTable(conA , conB, "DBM_TOOL_PERMISSION");
copyTable(conA , conB, "CUSTOM_OBJECT_TYPE");
copyTable(conA , conB, "CUSTOM_OBJECT");


dbm.closeResourceOnExit(conA);
dbm.closeResourceOnExit(conB);


def copyTable(conA, conB, String tableName, set = true){
   logger.info(tableName);

   def databaseMetaData = conA.getMetaData();
   ResultSet columns = databaseMetaData.getColumns(null,null, tableName, null);
   String SELECT = "";
   String INSERT = "";
   String VALUES = "";
   int count = 0;
   while(columns.next()) {
       String columnName = columns.getString("COLUMN_NAME");
       String generated = columns.getString("IS_GENERATEDCOLUMN")
       if (generated.equals("NO")) {
           SELECT += ", "+ columnName;
          INSERT += ", ["+columnName+"]";
          VALUES += ", ?";
          count ++;
      }
  } 
  INSERT = "INSERT INTO "+ tableName +"("+ INSERT.substring(2)+ ") values ("+VALUES.substring(2)+")";
  SELECT = "SELECT "+ SELECT.substring(2) + " FROM "+tableName;
  columns.close();
  
   Statement stmtA=conA.createStatement();  
   ResultSet rsA = stmtA.executeQuery(SELECT);
   
   Statement stmtB2;
   if (set){
      stmtB2 = conB.createStatement();  
      stmtB2 .execute("SET IDENTITY_INSERT "+tableName +" ON");
      stmtB2 .close();
   }

    PreparedStatement stmtB=conB.prepareStatement(INSERT);  
    
    int batch = 0;
    int processed = 0;
    while (rsA.next()){
          for (int i=1; i<=count; ++i){
                stmtB.setObject(i,  rsA.getObject(i));
          }
          stmtB.addBatch();
          if (++batch == 500){
                stmtB.executeBatch();
                batch = 0;
                logger.info("Progress: "+processed);
          }
          processed++;
    }
    stmtB.executeBatch();
    stmtB.close();

    rsA.close();

   if (set){
       stmtB2 = conB.createStatement();  
       stmtB2 .execute("SET IDENTITY_INSERT "+tableName +" OFF");
       stmtB2 .close();
    }

    println tableName+ " "+  processed+"<br>";
    logger.info(""+processed);
   
}
