#!/usr/bin/perl
use utf8;
use Encode;

# Created by Dmitriy Novikov. Script to make tables.

binmode(STDOUT, ":utf8");
require "./bdconf.pl";

my $dbh = DBI->connect($database, $user, $password);

$sql = "CREATE TABLE IF NOT EXISTS message (
        created TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, 
        id      VARCHAR NOT NULL, 
        int_id  CHAR(16) NOT NULL, 
        str     VARCHAR NOT NULL, 
        status  BOOL,  
        CONSTRAINT message_id_pk PRIMARY KEY(id)
        );";
    
$q1 = $dbh->prepare($sql);
if($q1->execute())
{
    print "table \"message\" created or it is exists.\n";
    $q1->finish;
        
    $sql = "CREATE INDEX message_created_idx ON message (created);
    CREATE INDEX message_int_id_idx ON message (int_id);";
        
    $q2 = $dbh->prepare($sql);
    if($q2->execute())
    {
        $q2->finish;
        print "indexes 'message_created_idx' and 'message_int_id_idx' created.\n";
    }
    else
    {
        print "Error on CREATE 'message_created_idx' and 'message_int_id_idx'.\n";
        
        print "\$dbh->errstr: ".$dbh->errstr."\n";
    }
}
else
{
    print "Error occured while table \"message\" creating.\n";
}
    

$sql = "CREATE TABLE IF NOT EXISTS log (
        created     TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
        int_id      CHAR(16) NOT NULL,
        str         VARCHAR,
        address     VARCHAR
        );";
    
$q1 = $dbh->prepare($sql);
if($q1->execute())
{
    print "table \"log\" created or it is exists.\n";
    $q1->finish;
        
    $sql = "CREATE INDEX log_address_idx ON log USING hash (address);";
        
    $q2 = $dbh->prepare($sql);
    if($q2->execute())
    {
        $q2->finish;
        print "index 'log_address_idx' created.\n";
    }
    else
    {
        print "Error on CREATE 'log_address_idx'.\n";
    }
}
else
{
    print "Error Table \"log\" creating.\n";
}
