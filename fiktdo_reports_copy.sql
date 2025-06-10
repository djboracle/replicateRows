DECLARE

   CURSOR crsrRetId IS
   select 
         id ret_id 
   from 
         reports@fiktdo.world
   where 
         date_modified >= TO_DATE('08/17/2024 0800','MM/DD/YYYY HH24MI')
   and   date_modified <=  TO_DATE('08/17/2024 1830','MM/DD/YYYY HH24MI')
   UNION
   select 
          ret_id
   from
          persons@fiktdo.world
   where 
          date_modified >= TO_DATE('08/17/2024 0800','MM/DD/YYYY HH24MI')
   and    date_modified <=  TO_DATE('08/17/2024 1830','MM/DD/YYYY HH24MI')
   UNION
   select 
          pen.ret_id
   from
          persons@fiktdo.world pen
   where 
         exists (select 'x' from master_names@fiktdo.world x where
	              x.pen_id = pen.id
             and  x.date_modified >= TO_DATE('08/17/2024 0800','MM/DD/YYYY HH24MI')
             and  x.date_modified <=  TO_DATE('08/17/2024 1830','MM/DD/YYYY HH24MI'))
   UNION
   select 
          pen.ret_id
   from
          persons@fiktdo.world pen
   where 
          exists (select 'x' from ban_information@fiktdo.world x where
	              x.pen_id = pen.id
               and  x.date_modified >= TO_DATE('08/17/2024 0800','MM/DD/YYYY HH24MI')
               and  x.date_modified <=  TO_DATE('08/17/2024 1830','MM/DD/YYYY HH24MI'))
   UNION
   select 
          loc.ret_id
   from
          locations@fiktdo.world loc
   where 
          loc.date_modified >= TO_DATE('08/17/2024 0800','MM/DD/YYYY HH24MI')
   and    loc.date_modified <=  TO_DATE('08/17/2024 1830','MM/DD/YYYY HH24MI')
   and    loc.ret_id is not  null
   UNION
   select 
          ret_id
   from
          fikt_report_shares@fiktdo.world
   where 
          date_modified >= TO_DATE('08/17/2024 0800','MM/DD/YYYY HH24MI')
   and    date_modified <=  TO_DATE('08/17/2024 1830','MM/DD/YYYY HH24MI')
   and    ret_id is not null;
   
BEGIN

   FOR data_rec IN crsrRetId LOOP

      replicateRows.copy(p_top_table_name      => 'REPORTS',
                         p_key_value           =>  data_rec.ret_id,
				         p_dblink_val          => 'FIKTDO.WORLD',
				         p_source_schema       => 'FIKTDO',
				         p_destination_schema  => 'FIKTDO',
				         p_execute             => FALSE,
					     p_commit              => FALSE);
					  
   END LOOP;

END;