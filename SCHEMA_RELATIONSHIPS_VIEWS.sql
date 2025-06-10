 DROP MATERIALIZED VIEW SCHEMA_RELATIONSHIPS_MV;
 CREATE MATERIALIZED VIEW SCHEMA_RELATIONSHIPS_MV AS
 SELECT  DISTINCT
          a.table_name                parent_table,
          NULL                        child_table,
          NULL                        fk_col,
		  NULL                        fk_col_id,
		  NULL                        fk_data_type,
		  NULL                        constraint_name
 FROM
          dba_cons_columns b,
          dba_constraints,
          dba_cons_columns a
 WHERE
          a.owner              = 'KBCOPSDO'
  AND     dba_constraints.r_constraint_name   = a.constraint_name
  AND     dba_constraints.owner               = a.owner
  AND     dba_constraints.constraint_type     = 'R'
  AND     b.owner                             = a.owner
  AND     b.constraint_name                   = dba_constraints.constraint_name
  UNION
  SELECT
          a.table_name                parent_table,
          dba_constraints.table_name  child_table,
          b.column_name               fk_col,
		  b.position                  fk_col_id,
		  c.data_type                 fk_data_type,
		  b.constraint_name           constraint_name
  FROM
          dba_tab_columns c,
          dba_cons_columns b,
          dba_constraints,
          dba_cons_columns a
  WHERE
          a.owner              = 'KBCOPSDO'
  AND     dba_constraints.r_constraint_name   = a.constraint_name
  AND     dba_constraints.owner               = a.owner
  AND     dba_constraints.constraint_type     = 'R'
  AND     b.owner                             = a.owner
  AND     b.constraint_name                   = dba_constraints.constraint_name
  AND     c.owner                             = 'KBCOPSDO'
  AND     c.table_name                        = b.table_name
  AND     c.column_name                       = b.column_name;

  DROP MATERIALIZED VIEW  SCHEMA_PK_COLS_MV; 
  CREATE MATERIALIZED VIEW SCHEMA_PK_COLS_MV AS
  SELECT
          a.table_name,
		  b.column_name pk_col,
		  b.position    pk_col_id,
		  c.data_type   data_type
  FROM
         user_tab_columns  c,
         user_cons_columns b, 
         user_constraints a 
  WHERE 
         a.constraint_type = 'P'
  AND    b.constraint_name = a.constraint_name
  AND    c.table_name  = b.table_name
  AND    c.column_name = b.column_name
  ORDER BY a.table_name,b.position;
  