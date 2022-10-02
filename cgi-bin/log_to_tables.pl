#!/usr/bin/perl

# Created by Dmitriy Novikov. The main script, which adding datas to tables

my $logFile = $ARGV[0];

if(($logFile ne '') && (-f $logFile))
{
    print "Вносим данные из лога в таблицы\n";
}
else
{
    print "Запуск программы осуществляется с аргументом <filename>";
    exit;
}

require "./mysubs.pl";

my $dbh = DBI->connect($database, $user, $password);

if($dbh)
{
    fileToBD($logFile, $dbh);
}
else
{
    print "couldn't connect to DB $database\n";
}

print $dbh->disconnect."\n";
print "Job is done.";





