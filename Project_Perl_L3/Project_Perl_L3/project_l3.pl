#!/usr/bin/perl
use strict;
use warnings;

# Initialize counters
my $successful_requests = 0;
my $failed_logins = 0;
my $specific_error = 0;
my %ip_count;

# Open the log file
open(my $fh, '<', '%SystemRoot%\System32\winevt\Logs') or die "Could not open file: $!";

#while (my $line = <$fh>) {
#    if ($line =~ /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\.*\[(.+)\]/){
#        my $ip = $1;
#        my $timestamp = $2;
#    }
#    
#}


while (my $line = <$fh>) {
    # Extract IP addresses, timestamps, and error codes
    if ($line =~ /^(\S+) (\S+) (\S+) \[(.+)\] "(\w+) (.+?) (\S+)" (\d{3}) (\d+|-)/) {
        my $ip = $1;
        my $timestamp = $4;
        my $status_code = $8;
        $ip_count{$ip}++;
        

        # Count successful requests
        if ($status_code =~ /^2\d{2}$/) {
            $successful_requests++;
        }

        # Count failed login attempts
        if ($status_code == 401) {
            $failed_logins++;
        }

        # Count specific error messages
        if ($status_code == 500) {
            $specific_error++;
        }
        
        
    }
}

# Close the log file
close($fh);

foreach my $ip (keys %ip_count){
    print ("IP: $ip - Occurences: $ip_count{$ip}\n");
}

# Print results
print "Summary:\n";

print "Successful Requests: $successful_requests\n";
print "Failed Logins: $failed_logins\n";
print "Specific Error (500): $specific_error\n";