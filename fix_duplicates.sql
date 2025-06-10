DECLARE

   CURSOR  crsrUpdate IS
   select 
          a.id,
          a.latest_approved_ver_flag
   from incidents@rmsprod.world a 
   where complaint_no in (select complaint_no from (select complaint_no,count('x') from incidents where latest_approved_ver_flag = 'Y' group by complaint_no having count('x') > 1));

   
  v_sql VARCHAR2(2000) := 'UPDATE incidents SET latest_approved_ver_flag = :1 WHERE id = :3';

BEGIN

   FOR data_rec IN crsrUpdate LOOP
   
     EXECUTE IMMEDIATE v_sql USING data_rec.latest_approved_ver_flag,data_rec.id;
   
   END LOOP;
   

END;