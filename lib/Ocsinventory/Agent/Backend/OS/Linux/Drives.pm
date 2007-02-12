package Ocsinventory::Agent::Backend::OS::Linux::Drivers;

use strict;
sub check {
  my $df = `df -TP`;
  return 1 if $df =~ /\w+/;
  0
}

sub run {
  my $params = shift;
  my $inventory = $params->{inventory};

  my $free;
  my $filesystem;
  my $total;
  my $type;
  my $volumn;


  foreach(`df -TP`) { # TODO retrive error
    if(/^(\S+)\s+(\S+)\s+(\S+)\s+(?:\S+)\s+(\S+)\s+(?:\S+)\s+(\S+)\n/){
      $free = sprintf("%i",($4/1024)); 
      $filesystem = $2;
      $total = sprintf("%i",($3/1024));
      $type = $1;
      $volumn = $5;

# no virtual FS
      next if ($type =~ /^(tmpfs|usbfs|proc|devpts|devshm)$/);

      $inventory->addDrives({
	  FREE => $free,
	  FILESYSTEM => $filesystem,
	  TOTAL => $total,
	  TYPE => $type,
	  VOLUMN =>
	  $volumn
	})
    }
  }
}

1;
