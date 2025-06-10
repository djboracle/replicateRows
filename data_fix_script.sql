DECLARE

   CURSOR crsrNewReports IS
   SELECT  distinct
           inc_id_for_validation id
   FROM
          ADDRESSES@rmsprod.world a
   WHERE
         a.date_created > TO_DATE('01/11/2018 0717','MM/DD/YYYY HH24MI')
   AND not exists (select 'x' from ADDRESSES b where b.id = a.id)
   and inc_id_for_validation > 0
   ORDER BY id ASC;


BEGIN

   FOR data_rec IN crsrNewReports LOOP

      replicateRows.copy(p_top_table_name      => 'INCIDENTS',
                         p_key_value           =>  data_rec.id,
				         p_dblink_val          => 'RMSPROD.WORLD',
				         p_source_schema       => 'KBCOPSDO',
				         p_destination_schema  => 'KBCOPSDO',
				         p_execute             => FALSE,
					     p_commit              => FALSE);
					  
   END LOOP;

END;

TRUNCATE TABLE REPLICATION_PROCESSING;

DECLARE

   CURSOR crsrRuns IS
   SELECT DISTINCT
          run_no
   FROM
          replication_processing
   WHERE
          process_msg != 'APPLIED'
   ORDER BY
          run_no asc;
          
    v_run_no VARCHAR2(200) := NULL;

BEGIN

   FOR data_rec IN crsrRuns LOOP
   
   v_run_no := data_rec.run_no;
   
   replicateRows.executeRun(p_run_no  => data_rec.run_no,
                            p_commit  => TRUE);
                            
   COMMIT;

   END LOOP;
   
EXCEPTION
  WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(v_run_no);
     RAISE;

END;

INSERT INTO MISSING_INC_REPORTS
SELECT
        id,
		complaint_no,
		incident_supplement_flag
FROM
        incidents@rmsprod.world a
WHERE
        a.date_created> TO_DATE('01/11/2018 0717','MM/DD/YYYY HH24MI')
AND     a.incident_supplement_flag = 'S'
AND     NOT EXISTS (select 'x' from incidents b where b.id = a.id);



select count('x') 
from 
      cases@rmsprod.world a 
where 
      a.date_created > TO_DATE('01/11/2018 0717','MM/DD/YYYY HH24MI')
AND not exists (select 'x' from cases b where b.id = a.id)