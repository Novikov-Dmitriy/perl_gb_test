#!/usr/bin/perl

# Created by Dmitriy Novikov. Web-form to search datas
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $cgi = new CGI; # create new CGI object

my $email = $cgi->param('address');

$cgi->charset('utf-8');

print $cgi->header('text/html;charset=utf-8;');

print $cgi->start_html
(
    -title => "Ку!",
    -script=>
        [
            {
                -language=>'JavaScript',
                -src=>'/js/checkform.js'
            },
        ],      
);

require "./bdconf.pl";

my $dbh = DBI->connect($database, $user, $password) or die "Couldn't connect to DB $database";
    
my $e = "\n<br>";
print "Электронные адреса из базы, относящиеся к которым данные имеются в обеих таблицах (указано 50 штук, хотя их больше):$e$e"; 

# Выбираем и выводим на страницу электронные адреса, 
# связанная с которыми информация есть в обеих таблицах.
# === Начало вывода электронных адресов ===
my $sql = 
    "
    SELECT 
        DISTINCT address 
    FROM log l
    RIGHT JOIN message m ON m.int_id = l.int_id
    LIMIT 50
    ";
    
$emails = "";

my $query = $dbh->prepare($sql);

if($query->execute())
{
    while(@t = $query->fetchrow())
    {
        $emails .= $t[0]."  ";
    }
}
$query->finish();
    
print $emails.$e.$e;
# === Конец вывода электронных адресов ===

print "Введите электронный адрес, информацию по которому желаете получить:$e";
print $cgi->start_form
(
    -name    => 'search_form',
    -id      => 'search_form',
    -method  => 'POST',
    -enctype => &CGI::URL_ENCODED,
    -onsubmit => "return validDateForm()",
    -action => '', 
).$e;
#bruakxie@inbox.ru ijcxzetfsijoedyg@hsrail.ru
# jbgijvsl@rufox.ru tqoq@rambler.ru
print $cgi->textfield
(
    -type      => 'email',
    -name      => 'address',
    -value     => 'bruakxie@inbox.ru',
    -size      => 50,
    -maxlength => 200,
    -minlength => 5,
).$e;

print $cgi->submit
(
    -name=>'search',
    -value=>'Искать'
).$e;

print $cgi->end_form;

if ($email ne "")
{
    ($address) = $email =~ /([\w|\.|-]+\@[\w|\.|-]+\.\w+)/; #На всякий случай проверяем, что это е-почта.
    
    $sql = "
    WITH T1 AS
    (
    SELECT
        m.created   dtStamp, 
        m.int_id    myID, 
        m.str       myMess 
    FROM message m
        JOIN log l ON m.int_id = l.int_id
    WHERE l.address='$address'
    )
    SELECT
        l.created   dtStamp,
        l.int_id    myID,
        l.str       myMess
    FROM log l
    WHERE l.address='$address'
    UNION 
    SELECT * FROM T1
    ORDER BY 2,1
    LIMIT 100
    ";
    
    print "$e Searching for records related to '$address'.$e$e";
    
    $query = $dbh->prepare($sql);
    
    if($query->execute())
    {
            while(@t = $query->fetchrow())
            {
                #$,=' ';
                print $t[0]." ".$t[1]." ".$t[2]." ".$t[3].$e.$e;
            }
    }
    else
    {
        print "Error.$e";
        print $dbh->errstr.$e;
    }
}

print $cgi->end_html;
