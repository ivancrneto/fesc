#!/usr/bin/perl

use Bio::SeqIO; # biblioteca perl de biotecnologia
use DBI; # biblioteca perl de acesso a banco de dados


	$database = "biotec"; # nome do banco de dados
	$host = "localhost"; # nome da maquina 
	$usuario = "root"; # usuario
	$senha = "1234"; # senha

	  # conectando ao banco de dados
	  my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host","$usuario", "$senha",{'RaiseError' => 1});

		# IMPORTANTE: DEFINIR O TIPO DE SEQUENCIA PROTEIN OU DNA
		#my $query = "select ID_SEQ, ORGANISM_NAME, SEQ from SEQUENCIA WHERE ALPHABET = 'DNA' AND length(SEQ) > 0"; # DNA
		my $query = "select ID_SEQ, ORGANISM_NAME, SEQ from SEQUENCIA WHERE ALPHABET = 'Protein' AND length(SEQ) > 0"; # PROTEIN
		#my $query = "select ID_SEQ, LOCUS, ORGANISM_NAME, SEQ from SEQUENCIA WHERE COMPLETE_SEQ = '1' AND ALPHABET = 'DNA' AND length(SEQ) > 0"; # DNA COMPLETAS
		
		#print $query , "\n\n";

		my $sth = $dbh->prepare($query);
		my $res = $sth->execute();

		open(sequencias, ">seq_nucleotideo_completas_locus.fasta"); # Abrir arquivo para escrita

		while(($ID_SEQ, $LOCUS, $SEQ, $ORGANISM) = $sth->fetchrow_array) {
			print "ID_SEQ:   " ,$ID_SEQ, "\n\n";
			print sequencias ">$ID_SEQ $LOCUS $ORGANISM\n";
			print sequencias "$SEQ\n";
			print sequencias "\n";
		}
		
		$sth->finish();
		
		close(sequencias);

exit;
