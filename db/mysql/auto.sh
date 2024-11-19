mysql -u root -p'prof.WonHo' < /tmp/db/create.sql
mysql -u root -p'prof.WonHo' okmindmap < /tmp/db/create_functions.sql
mysql -u root -p'prof.WonHo' okmindmap < /tmp/db/create_tables.sql
mysql -u root -p'prof.WonHo' okmindmap < /tmp/db/alterDb.sql
mysql -u root -p'prof.WonHo' okmindmap < /tmp/db/load_data.sql
echo "Okmindmap ready to use !"