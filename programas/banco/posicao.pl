#!/usr/bin/perl
	
use Bio::SeqIO; # biblioteca perl de biotecnologia
use DBI; # biblioteca perl de acesso a banco de dados


	$database = "biotec"; # nome do banco de dados
	$host = "localhost"; # nome da maquina 
	$usuario = "root"; # usuario
	$senha = "1234"; # senha

	# conectando ao banco de dados
	my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host","$usuario", "$senha",{'RaiseError' => 1});

	#my $query = "SELECT ID_SEQ, POSICAO FROM SEQUENCIA WHERE length(SEQ) > 0 ORDER BY ID_SEQ"; # Todos 
	#my $query = "SELECT ID_SEQ, POSICAO_DNA FROM SEQUENCIA WHERE ALPHABET = 'DNA' AND length(SEQ) > 0 ORDER BY ID_SEQ"; # DNA
	my $query = "SELECT ID_SEQ, POSICAO_PRO FROM SEQUENCIA WHERE ALPHABET = 'Protein' AND length(SEQ) > 0 ORDER BY ID_SEQ"; # Proteina
	#my $query = "SELECT ID_SEQ, POSICAO_COM FROM SEQUENCIA WHERE ALPHABET = 'DNA' AND COMPLETE_SEQ = '1' AND length(SEQ) > 0 ORDER BY ID_SEQ"; # DNA completas

	my $sth = $dbh->prepare($query);
	my $res = $sth->execute();

	my $sum = 1;
	
	while(($id) = $sth->fetchrow_array) {

		#my $qry = " UPDATE SEQUENCIA SET POSICAO = $sum WHERE ID_SEQ = $id "; # Todos 
		#my $qry = " UPDATE SEQUENCIA SET POSICAO_DNA = $sum WHERE ID_SEQ = $id "; # DNA
		my $qry = " UPDATE SEQUENCIA SET POSICAO_PRO = $sum WHERE ID_SEQ = $id "; # Proteina
		#my $qry = " UPDATE SEQUENCIA SET POSICAO_COM = $sum WHERE ID_SEQ = $id "; # DNA completas

		my $upd = $dbh->prepare($qry);
		my $u = $upd->execute();

		$sum = $sum + 1;
	}

	$sth->finish();

exit;


