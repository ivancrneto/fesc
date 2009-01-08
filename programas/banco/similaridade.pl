#!/usr/bin/perl

# utilizar o usuario root

use DBI; # biblioteca perl de acesso a banco de dados
use Bio::SeqIO; # biblioteca perl de biotecnologia
use Bio::SearchIO;
use Bio::Tools::Run::StandAloneBlast;
use Bio::Search::HSP::HSPI


  $database = "biotec"; # nome do banco de dados
  $host = "localhost"; # nome da maquina 
  $usuario = "root"; # usuario
  $senha = "1234"; # senha

  # conectando ao banco de dados
  my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host","$usuario", "$senha",{'RaiseError' => 1});

  # definindo o programa da plataforma BLAST e o banco de dados
  #@params = (program => 'blastp', database => 'seq_proteinas.fasta'); # programa para comparacao entre sequencia proteicas
  #@params = (program => 'blastn', database => 'seq_nucleotideo.fasta'); # programa para comparacao entre sequencia nucleotidicas
  @params = (program => 'blastn', database => 'seq_nucleotideo_completas.fasta'); # programa para comparacao entre sequencia nucleotidicas
  $factory = Bio::Tools::Run::StandAloneBlast->new(@params);

  #print "\n Id: " , $ARGV[1], "\n\n";
  #my $id_seq_alvo = $ARGV[1];

  # Observacao para PROTEINAS
  # Nao usar similaridade por que estamos trabalhando com proteinas levar em consideracao a identidade e o e-value  lendo o resultado

	#my $query = "select ID_SEQ, SEQ from SEQUENCIA WHERE ALPHABET = 'DNA' AND length(SEQ) > 0"; # DNA
	#my $query = "select ID_SEQ, SEQ from SEQUENCIA WHERE ALPHABET = 'Protein' AND length(SEQ) > 0"; # Protein
	my $query = "select ID_SEQ, SEQ from SEQUENCIA WHERE COMPLETE_SEQ = '1' AND ALPHABET = 'DNA' AND length(SEQ) > 0"; # DNA completas

	#print $query , "\n\n";

	my $sth = $dbh->prepare($query);
	my $res = $sth->execute();#
	my $qtd = 0;

	while(($id, $sequencia) = $sth->fetchrow_array) {

		 $qtd = $qtd + 1;
		 print "N: ", $qtd, "\n";

		 #@args = ("perl","similaridade.pl", &trim($sequencia), $id);
		 #system(@args) == 0 or die "system @args failed: $?";

		 # definindo a sequencia que sera comparada com todas do banco de dados
		 $input = Bio::Seq->new(-id=>"Seq",-seq=>$sequencia);

		 # executando o BLAST
		 $blast_report = $factory->blastall($input);

		 while (my $result = $blast_report->next_result)  {
		      while (my $hit = $result->next_hit)      {
			    while (my $hsp = $hit->next_hsp) {

			       #print " Nome: " , $hit->name,
		       	       #" per: " , $hsp->percent_identity,
			       #" Score: " , $hsp->score,
			       #" frac_identical: " , $hsp->frac_identical(),
			       #" num_identical: " , $hsp->num_identical(),
		     	       #" E: ", $hsp->evalue,
			       #" length: ", $hsp->length, 
			       #" gaps: ", $hsp->gaps, 
			       #" frac_identical: ", $hsp->frac_identical, 
			       #" frac_conserved: ", $hsp->frac_conserved, 
			       #" n: ", $hsp->n, 
			       #" matches: ", $hsp->matches, 
			       #" num_identical: ", $hsp->num_identical, 
			       #" num_conserved: ", $hsp->num_conserved,  
			       #"\n";

			       $string = $hsp->evalue;
			       $string = &Replace($string, ',', '');

		     	       &inserir($id, $hit->name, $hsp->percent_identity, $hsp->score, $string, $hsp->length, $hsp->gaps, $hsp->frac_identical, $hsp->frac_conserved, $hsp->n, $hsp->matches, $hsp->num_identical, $hsp->num_conserved);
			  }
		      }
		 }
	}

	$sth->finish();

	print "\nQtd: ", $qtd, "\n\n";


sub Replace {

	my $strString = shift;
	my $strSearch = shift;
	my $strReplace = shift;
	$strString =~ s/$strSearch/$strReplace/ge;
	return $strString;
}

sub inserir {

	my $query = "call pr_similaridade (" .  $_[0] . ",'".  $_[1] . "','".  $_[2] . "','".  $_[3] . "','" .  $_[4] . "','" .  $_[5] . "','" .  $_[6] . "','" .  $_[7] . "','" .  $_[8] . "','" .  $_[9] . "','" .  $_[10] . "','" .  $_[11] . "','" .  $_[12] . "');";

	#print $query , "\n\n";

	my $sth = $dbh->prepare($query);
	my $res = $sth->execute(); 
}

exit;
