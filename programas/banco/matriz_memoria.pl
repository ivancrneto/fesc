
use Bio::SeqIO; # biblioteca perl de biotecnologia
use DBI; # biblioteca perl de acesso a banco de dados


	$database = "biotec"; # nome do banco de dados
	$host = "localhost"; # nome da maquina 
	$usuario = "root"; # usuario
	$senha = "123456"; # senha

	# conectando ao banco de dados
	my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host","$usuario", "$senha",{'RaiseError' => 1});
	
	# DNA
	#my $query = "select DISTINCT ID_SEQ, POSICAO_DNA from SEQUENCIA, SIMILARIDADE where ALPHABET = 'DNA' AND ID_SEQ = COD_SEQ_ALVO order by POSICAO_DNA"; 

	# Proteinas
	#my $query = "select DISTINCT ID_SEQ, POSICAO_PRO from SEQUENCIA, SIMILARIDADE where ALPHABET = 'Protein' AND ID_SEQ = COD_SEQ_ALVO order by POSICAO_PRO"; 

	# DNA Completas
	my $query = "select DISTINCT ID_SEQ, POSICAO_COM from SEQUENCIA, SIMILARIDADE where COMPLETE_SEQ = '1' AND ALPHABET = 'DNA' AND ID_SEQ = COD_SEQ_ALVO order by POSICAO_COM"; 

	# Randomica
	#my $query = "select ID_SEQ from SEQUENCIA, SIMILARIDADE where GI = COD_SEQ_ALVO order by rand() limit 5000 "; 
					
	my $sth = $dbh->prepare($query);
	my $res = $sth->execute();

	#my $qry = "select count(*) as result from SEQUENCIA WHERE ALPHABET = 'DNA' AND length(SEQ) > 0"; # DNA
	#my $qry = "select count(*) as result from SEQUENCIA WHERE ALPHABET = 'Protein' AND length(SEQ) > 0"; # Protein
	my $qry = "select count(*) as result from SEQUENCIA WHERE COMPLETE_SEQ = '1' AND ALPHABET = 'DNA' AND length(SEQ) > 0"; # DNA Completas

	#my $qry = "select 50 as result";
	
	my $pro = $dbh->prepare($qry);
	my $p = $pro->execute();

	my $seqAlvo = 0;
	my $i = 1; # sequencia que esta sendo trabalhada

	my $tot = $pro->fetchrow_array; # Pegando quanridade total de proteinas
	
	while(($id) = $sth->fetchrow_array) {

		$seqAlvo = $id;

		print "Sequencia ->  $seqAlvo \n";

		# DNA
		#my $qry = "select distinct p.POSICAO_DNA, FLOOR(PERCENTUAL) as PERCENTUAL from(select COD_SEQ_SIMILIAR, PERCENTUAL from SEQUENCIA p, SIMILARIDADE s where ID_SEQ = $seqAlvo and ID_SEQ = COD_SEQ_ALVO and COD_SEQ_ALVO <> COD_SEQ_SIMILIAR) as temp , SEQUENCIA p where p.ID_SEQ = COD_SEQ_SIMILIAR order by p.POSICAO_DNA;";
		
		# Protein
		#my $qry = "select distinct p.POSICAO_PRO, FLOOR(PERCENTUAL) as PERCENTUAL from(select COD_SEQ_SIMILIAR, PERCENTUAL from SEQUENCIA p, SIMILARIDADE s where ID_SEQ = $seqAlvo and ID_SEQ = COD_SEQ_ALVO and COD_SEQ_ALVO <> COD_SEQ_SIMILIAR) as temp , SEQUENCIA p where p.ID_SEQ = COD_SEQ_SIMILIAR order by p.POSICAO_PRO;";

		# DNA Completas
		my $qry = "select distinct p.POSICAO_COM, FLOOR(PERCENTUAL) as PERCENTUAL from(select COD_SEQ_SIMILIAR, PERCENTUAL from SEQUENCIA p, SIMILARIDADE s where ID_SEQ = $seqAlvo and ID_SEQ = COD_SEQ_ALVO and COD_SEQ_ALVO <> COD_SEQ_SIMILIAR) as temp , SEQUENCIA p where p.ID_SEQ = COD_SEQ_SIMILIAR order by p.POSICAO_COM;";

		my $simi = $dbh->prepare($qry);
		my $sim  = $simi->execute();

		while(($posicao, $similaridade) = $simi->fetchrow_array) {
					
		    $resultBanco{$posicao} = {
		       similaridade => $similaridade,
		    };
		}

		my $temp = 0;

		for( $k = 1 ; $k <= $tot ; $k++ ) {

		     # montando matriz
		     for $j (keys %resultBanco) {
		       if($k == $j) {
			 $temp = $resultBanco{$j}->{similaridade};
		       }
		   }

		   $matriz{$i}{$k} = { n => $temp};
		   $temp = 0;
		}

		print "  Gerou\n\n";
		
		# limpando lista
		for $u (keys %resultBanco) {
		   delete $resultBanco{$u};
		}
		
		$i = $i + 1;

		$simi->finish();
	}

	$sth->finish();

	my $tempX = 0; # linha
	my $tempY = 0; # coluna

	print "Percorrendo da matriz \n\n";
	# percorrendo da matriz para forcar a similaridade
	for( $i = 1 ; $i <= $tot ; $i++ ) {

		 for( $j = $i ; $j <= $tot ; $j++ ) {

			#print " i: $i  j: $j \n";
			$tempX = $matriz{$i}{$j}->{n};  
			$tempY = $matriz{$j}{$i}->{n};

			print " tempX: $tempX  tempY: $tempY \n";

			# forcando similaridade, atribuindo o valor do maior
			if ($tempX > $tempY) {
				$matriz{$i}{$j} = { n => $tempX};
				$matriz{$j}{$i} = { n => $tempX};
			} else {
				$matriz{$i}{$j} = { n => $tempY};
				$matriz{$j}{$i} = { n => $tempY};
			}
		 }

		 $tempX = 0;
		 $tempY = 0;
		 #print "Elemento i: $i \n";
	}

	print "Escrevendo matriz no arquivo \n\n";

	open(sequencias, ">matriz_DNA_COMPLETAS.txt"); # Abrir arquivo para escrita

	for( $i = 1 ; $i <= $tot ; $i++ ) {

	   for( $j = 1 ; $j <= $tot ; $j++ ) {
	      print sequencias $matriz{$i}{$j}->{n}. " ";
	   }
	   print sequencias "\n";
	}

	close(sequencias);

	print "Finalizado \n\n";
exit;


