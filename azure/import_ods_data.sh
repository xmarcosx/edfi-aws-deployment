psql -h $1 -U postgres@edfi-ods  'EdFi_Admin' < /home/vscode/edfi-ods-admin/EdFi_Admin.sql;
psql -h $1 -U postgres@edfi-ods  'EdFi_Security' < /home/vscode/edfi-ods-security/EdFi_Security.sql;
psql -h $1 -U postgres@edfi-ods  'EdFi_Ods' < /home/vscode/edfi-ods-minimal/EdFi.Ods.Minimal.Template.sql;

for FILE in `LANG=C ls /home/vscode/edfi-ods-admin-scripts/PgSql/* | sort -V`
    do
        psql -h $1 -U postgres@edfi-ods 'EdFi_Admin' < $FILE 
    done
