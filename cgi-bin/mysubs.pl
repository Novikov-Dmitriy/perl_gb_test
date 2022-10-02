require "./bdconf.pl";

# Created by Dmitriy Novikov. Script with subprogram.

sub fileToBD
{
    my $myFile = shift;
    my $dbh = shift;
    
    open($fh, $myFile) || die "couldn't open file $myFile";
    
    my $to_message = 0;
    my $to_log = 0;
    
    my $sql = "";
    
    my $count = 0;
    
    while ($line = <$fh>)
    {
        ($date, $time, $int_id, $rest) = 
            $line =~ /(\d{4}-\d{2}-\d{2})\s(\d{2}:\d{2}:\d{2})\s(\S+)(.+)/;
            
        my $str = $rest;

        ($flag, $end2) = $rest =~ /\s?(<=|=>|->|\*\*|==)?\s?(.+)/;
        
        ($address) = $end2 =~ /^([\w|\.|-]+\@[\w|\.|-]+\.\w+)?/;
        
        ($id) = $end2 =~ /.+\sid=(\S+)/;
            
        $str =~ s/'/''/; #Меняем в сообщениях одинарные кавычки на дважды одинарные, чтоб SQL он не сбоил.
        
        if(($flag eq "<=") && ($id ne ''))
        {
            $sql = "INSERT INTO message (created,id,int_id,str) 
            VALUES (TO_TIMESTAMP('$date $time','YYYY-MM-DD HH24:MI:SS'),'$id','$int_id','$str')";
            $to_message++;
        }
        else
        {
            $sql = "INSERT INTO log (created,int_id,str,address) 
            VALUES (TO_TIMESTAMP('$date $time','YYYY-MM-DD HH24:MI:SS'),'$int_id','$str','$address')";
            $to_log++;
        }
        
        $query = $dbh->prepare($sql);
        
        if(!$query->execute())
        {
            print "Error:\n $sql \n\n";
            print $dbh->errstr.\n;
        }
        $query->finish();
        
        ($date, $time, $int_id, $rest) = ("","","","");
        ($flag, $address, $end2) = ("","","");
        $str = "";
        $id = "";

        if($count++ > 250)
        {
            $count = 0;
            print "\n To table 'message' added: $to_message \n To table 'log' added: $to_log \n";
        }
    }
    
    print "\n To table 'message' added: $to_message \n To table 'log' added: $to_log \n";
    
    close($fh);
}

