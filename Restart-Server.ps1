$Servers = import-csv C:\AGMLogs\RebootRequired.csv

foreach ($node in $Servers) { 

    Restart-Computer -ComputerName $node.PSComputerName -Verbose -Force 






}