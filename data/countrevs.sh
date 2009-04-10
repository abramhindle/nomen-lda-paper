FILE="UNICODE DEC/OSF1 ODBC crash SQLCLI SYSDD.cpnix kacup select make memory view debug"
for file in $FILE
do
	fgrep -w -i -- "$file" query1.mrs2
done
