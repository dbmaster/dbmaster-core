ALTER TABLE CUSTOMFIELDENTITY_MAP ALTER COLUMN BOOL RENAME TO FLAG_VALUE;
ALTER TABLE CUSTOMFIELDENTITY_MAP ALTER COLUMN FRACTIONAL RENAME TO FLOAT_VALUE;
ALTER TABLE CUSTOMFIELDENTITY_MAP ALTER COLUMN TEXT RENAME TO TEXT_VALUE;
ALTER TABLE CUSTOMFIELDENTITY_MAP ALTER COLUMN TIME RENAME TO TIME_VALUE;


ALTER TABLE CUSTOMFIELDENTITY_MAP ALTER COLUMN INTEGER RENAME TO INT_VALUE;
-- ALTER TABLE CUSTOMFIELD_VALUE ALTER COLUMN INTEGER RENAME TO INT_VALUE;

ALTER TABLE CUSTOMFIELDENTITY_MAP DROP COLUMN NOT_NULL_COLUMN;
ALTER TABLE CUSTOMFIELDENTITY_MAP ADD COLUMN UPDATED_AT TIMESTAMP;
ALTER TABLE CUSTOMFIELDENTITY_MAP ADD COLUMN UPDATED_BY VARCHAR(15);
ALTER TABLE CUSTOMFIELDENTITY_MAP ADD COLUMN ENTITY_TYPE NVARCHAR(32);
ALTER TABLE CUSTOMFIELDENTITY_MAP ADD COLUMN VALUE_ORDER SMALLINT;
UPDATE CUSTOMFIELDENTITY_MAP SET VALUE_ORDER = 0;
ALTER TABLE CUSTOMFIELDENTITY_MAP ALTER COLUMN VALUE_ORDER SET NOT NULL;

ALTER TABLE CUSTOM_OBJECT ADD COLUMN CLAZZ VARCHAR(32);

UPDATE CUSTOM_OBJECT co set CLAZZ = (select ce.CLAZZ from CUSTOMFIELDENTITY ce where ce.ID = co.CUSTOM_ID);


ALTER TABLE CUSTOM_OBJECT ADD COLUMN OBJECT_TYPE_ID BIGINT;

UPDATE CUSTOM_OBJECT co SET OBJECT_TYPE_ID = (SELECT ID FROM CUSTOM_OBJECT_TYPE ct WHERE ct.CLAZZ = co.clazz AND ct.project_id = co.project_id);


UPDATE CUSTOMFIELDENTITY_MAP cm SET ENTITY_TYPE = 'CustomObject'
   WHERE CUSTOMFIELDENTITY_ID IN (SELECT t.CUSTOM_ID FROM CUSTOM_OBJECT t WHERE t.OBJECT_TYPE_ID IS NOT NULL);



DELETE FROM CUSTOM_OBJECT WHERE CLAZZ IS NULL OR OBJECT_TYPE_ID IS NULL;



UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_TYPE = (SELECT ce.CLAZZ FROM CUSTOMFIELDENTITY ce WHERE ce.ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE IS NULL;

UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.UPDATED_AT = (SELECT ce.UPDATED FROM CUSTOMFIELDENTITY ce WHERE ce.ID = cm.CUSTOMFIELDENTITY_ID);

UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.UPDATED_BY = (SELECT ce.UPDATEAUTHOR FROM CUSTOMFIELDENTITY ce WHERE ce.ID = cm.CUSTOMFIELDENTITY_ID);

ALTER TABLE CUSTOMFIELDENTITY_MAP ALTER COLUMN ENTITY_TYPE SET NOT NULL;

ALTER TABLE CUSTOMFIELDENTITY_MAP ALTER COLUMN UPDATED_AT SET NOT NULL;

ALTER TABLE CUSTOMFIELDENTITY_MAP ADD COLUMN ENTITY_ID BIGINT;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID FROM CUSTOM_OBJECT t WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'CustomObject';
 

ALTER TABLE CUSTOM_OBJECT DROP COLUMN CUSTOM_ID;
ALTER TABLE CUSTOM_OBJECT DROP COLUMN CLAZZ;
-- ???? project_id
ALTER TABLE CUSTOM_OBJECT DROP COLUMN project_id;
ALTER TABLE CUSTOM_OBJECT ALTER COLUMN OBJECT_TYPE_ID SET NOT NULL;

ALTER TABLE CUSTOM_OBJECT
    ADD CONSTRAINT FK_CUSTOM_OBJECT_TYPE_CUSTOM_OBJECT_OBJECT_TYPE_ID
    FOREIGN KEY (OBJECT_TYPE_ID)
    REFERENCES CUSTOM_OBJECT_TYPE(ID)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

-- update entities

UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM INV_APPLICATION t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'Application';
ALTER TABLE INV_APPLICATION DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM INV_APPLICATION_LINK t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'ApplicationLink';
ALTER TABLE INV_APPLICATION_LINK DROP COLUMN CUSTOM_ID;

UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM INV_CONTACT t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'Contact';
ALTER TABLE INV_CONTACT DROP COLUMN CUSTOM_ID;

UPDATE CUSTOMFIELDENTITY_MAP cm
   SET cm.ENTITY_ID = (SELECT t.ID FROM inv_contact_link t WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
   WHERE cm.ENTITY_TYPE = 'ContactLink';
ALTER TABLE inv_contact_link DROP COLUMN CUSTOM_ID;

UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID FROM inv_database t WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'Database';

ALTER TABLE inv_database DROP COLUMN CUSTOM_ID;

UPDATE CUSTOMFIELDENTITY_MAP cm
   SET cm.ENTITY_ID = (SELECT t.ID FROM db_connection t WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
   WHERE cm.ENTITY_TYPE = 'Connection';

ALTER TABLE db_connection DROP COLUMN CUSTOM_ID;

























UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM db_column t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'Column';
ALTER TABLE db_column DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM db_constraint t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'Constraint';
ALTER TABLE db_constraint DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM db_foreign_key t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'ForeignKey';
ALTER TABLE db_foreign_key DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM db_index t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'Index';
ALTER TABLE db_index DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM db_model t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'Model';
ALTER TABLE db_model DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM db_model_object t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID AND t.DTYPE='3Func')
WHERE cm.ENTITY_TYPE = 'Function';























UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM db_model_object t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID AND t.DTYPE='2Proc')
WHERE cm.ENTITY_TYPE = 'Procedure';

UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM db_model_object t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID AND t.DTYPE='1View')
WHERE cm.ENTITY_TYPE = 'View';

UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM db_model_object t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID AND t.DTYPE='0Tabl')
WHERE cm.ENTITY_TYPE = 'Table';

UPDATE CUSTOMFIELDENTITY_MAP cm SET cm.ENTITY_TYPE = 'ModelObject'
WHERE cm.ENTITY_ID IN (SELECT ID FROM db_model_object)
AND (cm.ENTITY_TYPE = 'Table' OR cm.ENTITY_TYPE = 'View' OR cm.ENTITY_TYPE = 'Procedure' OR cm.ENTITY_TYPE = 'Function');

ALTER TABLE db_model_object DROP COLUMN CUSTOM_ID;
















UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM inv_database_usage t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'DatabaseUsage';
ALTER TABLE inv_database_usage DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM dbm_sync_session t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'SyncSession';
ALTER TABLE dbm_sync_session DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM inv_external_link t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'ExternalLink';
ALTER TABLE inv_external_link DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM DBM_FEED_ITEM t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'FeedItem';
ALTER TABLE DBM_FEED_ITEM DROP COLUMN CUSTOM_ID;























UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM inv_app_instance t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'Installation';

ALTER TABLE inv_app_instance DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM inv_job t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'Job';
ALTER TABLE inv_job DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM inv_security_object t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'SecurityObject';
ALTER TABLE inv_security_object DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM inv_security_object_link t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'SecurityObjectLink';
ALTER TABLE inv_security_object_link DROP COLUMN CUSTOM_ID;


UPDATE CUSTOMFIELDENTITY_MAP cm
SET cm.ENTITY_ID = (SELECT t.ID
FROM inv_server t
WHERE t.CUSTOM_ID = cm.CUSTOMFIELDENTITY_ID)
WHERE cm.ENTITY_TYPE = 'Server';
ALTER TABLE inv_server DROP COLUMN CUSTOM_ID;



ALTER TABLE COLLABORATION_TOPIC DROP COLUMN CUSTOM_ID;


-- end data move

DELETE FROM CUSTOMFIELDENTITY_MAP WHERE ENTITY_ID IS NULL;


ALTER TABLE CUSTOMFIELDENTITY_MAP DROP CONSTRAINT FK_CUSTOMFIELDENTITY_CUSTOMFIELDENTITY_MAP_CUSTOMFIELDENTITY_ID;
DROP TABLE CUSTOMFIELDENTITY;


ALTER TABLE CUSTOMFIELDENTITY_MAP DROP PRIMARY KEY;
ALTER TABLE CUSTOMFIELDENTITY_MAP DROP COLUMN CUSTOMFIELDENTITY_ID;
ALTER TABLE CUSTOMFIELDENTITY_MAP ALTER COLUMN ENTITY_ID SET NOT NULL;

ALTER TABLE CUSTOMFIELDENTITY_MAP ALTER COLUMN MAP_KEY RENAME TO FIELD_NAME;

-- ?? unnamed primary key
ALTER TABLE CUSTOMFIELDENTITY_MAP ADD PRIMARY KEY (ENTITY_TYPE,ENTITY_ID,FIELD_NAME,VALUE_ORDER);


ALTER TABLE CUSTOMFIELDENTITY_MAP RENAME TO CUSTOMFIELD_VALUE;

-- select * from CUSTOMFIELD_VALUE


CREATE VIEW TOOL_PERMISSION AS
SELECT TP.PROJECT_ID, TP.TOOL_ID,TP.USER_ID, 
MAX(CASEWHEN(ACCESS_EXECUTE,1,-1) * CASEWHEN(TP.USER_ID IS NULL,1,10))>0 AS ACCESS_EXECUTE,
MAX(CASEWHEN(ACCESS_VIEW_HISTORY,1,-1) * CASEWHEN(TP.USER_ID IS NULL,1,10))>0 AS ACCESS_VIEW_HISTORY
FROM DBM_TOOL_PERMISSION TP 
GROUP BY  TP.PROJECT_ID, TP.TOOL_ID, TP.USER_ID;


CREATE VIEW DBM_TOOL_HISTORY_DURATION AS 
SELECT TH.*, TIMESTAMPDIFF(SQL_TSI_MILLI_SECOND, TH.start, COALESCE(TH.finish,CURRENT_TIMESTAMP)) as DURATION  FROM DBM_TOOL_HISTORY TH;