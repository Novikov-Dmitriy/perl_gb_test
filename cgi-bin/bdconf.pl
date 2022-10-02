
use DBI;

#$database = "DBI:mysql:perl_test";
$dbName = "perl_test"; # Setup dbname 
$database = "DBI:Pg:dbname=perl_test"; # DB name, the same as above
$user = ""; # Setup username for your DB.
$password = ""; # Setup password for that user


if($password eq "")
{
    print "\n\n !!! Please set up database configuration in bdconf.pl file !!! \n\n";
}
