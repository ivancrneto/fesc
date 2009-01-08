# Para que esse script funcione corretamente a variavel max_allowed_packet (mysqld) deve ser setada com o valor 64M seguindo exemplo abaixo
# No Windows o arquivo modificado deve ser o my.ini
# [mysqld]
# max_allowed_packet = 64M
# No linux o arquivo modificado deve ser o my.cnf
#
# Marcelo
#


use Bio::SeqIO; # biblioteca perl de biotecnologia
use DBI; # biblioteca perl de acesso a banco de dados


	$database = "biotec"; # nome do banco de dados
	$host = "localhost"; # nome da maquina 
	$usuario = "root"; # usuario
	$senha = "123456"; # senha

	# conectando ao banco de dados
	my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host","$usuario", "$senha",{'RaiseError' => 1});

	my $objSeq = Bio::SeqIO->new('-file' => "<$ARGV[0]", '-format' => "genbank" );

	my $fileName = "$ARGV[0]";  # variavel que recebe o nome do arquivo de entrada
	
	my $cont = 0;  # variavel de controle
	
	print "\n\n";

	print $fileName, "\n\n";


	while (my $seq = $objSeq->next_seq) {

				my $arquivo = $fileName;
				
				my $locus = $seq->display_id;
				my $definition = $seq->desc;
				my $gi = $seq->primary_id;
				my $keywords = $seq->keywords;
				my $alphabet = $seq->alphabet;
				my $sequence = $seq->seq;
				
				$locus 		=~ s/["'"]/\_/g; # retirando aspas para inserir no banco de dados
				$definition =~ s/["'"]/\_/g; # retirando aspas para inserir no banco de dados
				$gi 		=~ s/["'"]/\_/g; # retirando aspas para inserir no banco de dados
				$keywords   =~ s/["'"]/\_/g; # retirando aspas para inserir no banco de dados
				$alphabet   =~ s/["'"]/\_/g; # retirando aspas para inserir no banco de dados
				$sequence   =~ s/["'"]/\_/g; # retirando aspas para inserir no banco de dados

				$organism = "";

				#for my $objFeatures ($seq->get_SeqFeatures) {
				#    if ($objFeatures->primary_tag eq "source") {
				#	$organism = $objFeatures->get_tag_values('organism');
				#    }		
				#}

  				for($seq->species->classification()){
				  $organism =  $organism . $_ . ";";
				}
				
				$organism   =~ s/["'"]/\_/g; # retirando aspas para inserir no banco de dados

				print "Locus : ", $locus, "\n";
				#print "Definition : ", $definition, "\n";
				print "Gi: ", $gi, "\n";
				#print "Keywords: ", $keywords, "\n";								
				#print "organism: ", $organism , "\n";
				print "Alphabet: ", $alphabet , "\n";
				print "Sequence: ", length($sequence) , "\n";
								
				$cont = $cont + 1;

				print $cont, "\n\n";

				#&sequencias($locus, $definition, $gi, $keywords, $organism, $sequence, $arquivo, $alphabet);
  }

  $dbh->disconnect;
  close($fileName);


sub sequencias {

		my $query = "call pr_sequencias('" .  $_[0] . "','".  $_[1] . "','".  $_[2] . "','" .  $_[3] . "','" .  $_[4] . "','" .  $_[5] . "','" .  $_[6] . "','" .  $_[7] . "');";
		
		#open (ARQUIVO, ">erro.txt"); 
		#print ARQUIVO $query;
		#close (ARQUIVO);

		#print $query , "\n\n";

		$dbh->do($query);
		#my $res = $sth->execute(); 

}

exit;
