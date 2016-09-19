--No usar con usuario sysdba o administrador, xq elimina las tablas del sistema
SET SERVEROUTPUT ON;
BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                     FROM user_objects
                    WHERE object_type IN
                             ('TABLE',
                              'VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'TYPE'
                             ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE'
         THEN
            DBMS_OUTPUT.put_line (   'EXITOSO: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );        
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS FORCE';
         ELSIF cur_rec.object_type = 'SEQUENCE'         
         THEN
            DBMS_OUTPUT.put_line (   'EXITOSO: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
             EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' '
                              || cur_rec.object_name
                              || '';                                
         ELSIF cur_rec.object_type = 'PROCEDURE'         
         THEN
            DBMS_OUTPUT.put_line (   'EXITOSO: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
             EXECUTE IMMEDIATE    'DROP PROCEDURE '
                              || cur_rec.object_name
                              || '';                 
         ELSE
            DBMS_OUTPUT.put_line (   'EXITOSO: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" FORCE';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (   'FALLO: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
END;
