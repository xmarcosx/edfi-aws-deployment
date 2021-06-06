PGPASSWORD=$2 psql -h $1 -U postgres  'EdFi_Admin' < /home/vscode/edfi-ods-admin/EdFi_Admin.sql;
PGPASSWORD=$2 psql -h $1 -U postgres  'EdFi_Security' < /home/vscode/edfi-ods-security/EdFi_Security.sql;
PGPASSWORD=$2 psql -h $1 -U postgres  'EdFi_Ods' < /home/vscode/edfi-ods-minimal/EdFi.Ods.Minimal.Template.sql;

for FILE in `LANG=C ls /home/vscode/edfi-ods-admin-scripts/PgSql/* | sort -V`
    do
        PGPASSWORD=$2 psql -h $1 -U postgres 'EdFi_Admin' < $FILE 
    done
