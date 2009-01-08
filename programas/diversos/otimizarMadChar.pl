#!/bin/perl

  $diretorio = "./";# definindo diretorio de trabalho. Local

  $qtdVertices = "27"; # quantidade de vertices da rede

  opendir(diretorio, "$diretorio");
  @lista = readdir(diretorio);
  closedir(diretorio);

  # Listando todos arquivos do diretorio
  foreach $arquivo(@lista){

    # Restringindo arquivos que serao utizados. Somente TXT
    if ( substr($arquivo, index($arquivo,"."), length($arquivo) ) eq ".txt"){

	# Criando arquivo de entrada para o MadChar
	open(emadch, ">emadch.dat"); # Abrir arquivo para escrita
	print emadch "5 ". $qtdVertices ." 1 300 0 1\n";
	print emadch "$arquivo\n";
	print emadch "ResultAnaliseMadChar\n";
	print emadch "0\n";
	print emadch "-1 0 0 0 0 0\n";
	close(emadch);

        #Compilando o MadChar
        @args = ("g77","madchar.f");
        system(@args) == 0 or die "system @args failed: $?";

	#Executando o MadChar
        @args = ("./a.out"," ");
        system(@args) == 0 or die "system @args failed: $?";

	&ResultAnalise_7($arquivo); # Manipulando arquivo 7
	&ResultAnalise_8($arquivo); # Manipulando arquivo 8
	&ResultAnalise_9($arquivo); # Manipulando arquivo 9
	&ResultAnalise_13($arquivo); # Manipulando arquivo 13
	&ApagarTodos(); # Apagando todos arquivo criados pelo MadCharprint

    }

  }

sub ResultAnalise_7 {

	$nomeArquivo = $_[0];
	$cont = 0;
	$valorAglomeracaoMedia = "";
	@linhas = ("");

	open(arq, "<ResultAnalise_7.dat"); # Abrir arquivo para leitura

	# loop para pegar a linha do coeficiente de aglomeracao medio. Linha 4
	while (<arq>)  {
	  
	  $cont = $cont + 1;
	  
	   if ($cont == 4) {
	    push(@linhas,$_);
	   }

	}
	
	close(arq);
	
	$valorAglomeracaoMedia = $linhas[1]; # passando elemanto do vertor para string
	$valorAglomeracaoMedia = substr($valorAglomeracaoMedia, 1, 15 );# pegando a parte significativa da string
	#print $valorAglomeracaoMedia;
	#print $nomeArquivo;

	open(resultCAM, ">>ResultCoeficienteAglomeracaoMedio.dat");
	print resultCAM $nomeArquivo ." ". $valorAglomeracaoMedia . "\n";
	close(resultCAM);

}

sub ResultAnalise_8 {

	$nomeArquivo = $_[0];
	$cont = 0;

	$valorAssortatividade = "";
	$valorGrauMedio = "";

	@linhasGrauMedia = ("");
	@linhasAssortatividade = ("");
	
	open(arq, "<ResultAnalise_8.dat"); # Abrir arquivo para leitura

	# loop para pegar a linha da Assortatividade e do Grau medio. Linha 3 e 4
	while (<arq>)  {
	  
	  $cont = $cont + 1;#
	  
	   if ($cont == 3) {
	    push(@linhasAssortatividade,$_);
	   }

	   if ($cont == 6) {
	    push(@linhasGrauMedia,$_);
	   }
	}
	
	close(arq);
	
	$valorAssortatividade = $linhasAssortatividade[1]; # passando elemanto do vertor para string
	$valorAssortatividade = substr($valorAssortatividade, 1, 15 );# pegando a parte significativa da string

	$valorGrauMedio = $linhasGrauMedia[1]; # passando elemanto do vertor para string
	$valorGrauMedio = substr($valorGrauMedio, 1, 15 );# pegando a parte significativa da string

	#print $valorAssortatividade;
	#print $valorGrauMedio;
	#print $nomeArquivo;

	open(resultGM, ">>ResultGrauMedio.dat");
	print resultGM $nomeArquivo ." ". $valorGrauMedio . "\n";
	close(resultGM);

	open(resultAss, ">>ResultAssortatividade.dat");
	print resultAss $nomeArquivo ." ". $valorAssortatividade . "\n";
	close(resultAss);

}

sub ResultAnalise_9 {

	$nomeArquivo = $_[0];
	$cont = 0;
	$valorDistanciaMinimaMedia = "";
	@linhas = ("");

	open(arq, "<ResultAnalise_9.dat"); # Abrir arquivo para leitura

	# loop para pegar a linha da distancia minima media. Linha 3
	while (<arq>)  {
	  
	  $cont = $cont + 1;
	  
	   if ($cont == 3) {
	    push(@linhas,$_);
	   }

	}
	
	close(arq);
	
	$valorDistanciaMinimaMedia = $linhas[1]; # passando elemanto do vertor para string
	$valorDistanciaMinimaMedia = substr($valorDistanciaMinimaMedia, 1, 15 );# pegando a parte significativa da string
	#print $valorDistanciaMinimaMedia;
	#print $nomeArquivo;

	open(resultCAM, ">>ResultDistanciaMinimaMedia.dat");
	print resultCAM $nomeArquivo ." ". $valorDistanciaMinimaMedia . "\n";
	close(resultCAM);

}

sub ResultAnalise_13 {

	$nomeArquivo = $_[0];
	$cont = 0;
	$valorX1 = "";
	$valorX2 = "";
	$valorY1 = "";
	$valorY2 = "";

	$parteX1 = "";
	$parteX2 = "";
	$parteY1 = "";
	$parteY2 = "";

	$valorLinhaX = "";
	$valorLinhaY = "";

	$dimensaoFractal = "";

	$deltaX = "";
	$deltaY = "";

	@linhasX = ("");
	@linhasY = ("");

	open(arq, "<ResultAnalise_13.dat"); # Abrir arquivo para leitura

	# loop para pegar a dimensão fractal. Linhas 2 e 3
	while (<arq>)  {
	  
	  $cont = $cont + 1;
	  
	   if ($cont == 2) {
	    push(@linhasX,$_);
	   }

	   if ($cont == 3) {
	    push(@linhasY,$_);
	   }

	}
	
	close(arq);
	
	$valorLinhaX = $linhasX[1]; # passando elemanto do vertor para string
	$valorX1 = substr($valorLinhaX, 2, 15 );# pegando a parte significativa da string
	$valorX2 = substr($valorLinhaX, 16, 30 );# pegando a parte significativa da string

	$valorLinhaY = $linhasY[1]; # passando elemanto do vertor para string
	$valorY1 = substr($valorLinhaY, 2, 15 );# pegando a parte significativa da string
	$valorY2 = substr($valorLinhaY, 16, 30 );# pegando a parte significativa da string

	$parteX1 = substr($valorX1, index($valorX1,"E") + 2, length($valorX1));	
	$valorX1 = substr($valorX1, 0, index($valorX1,"E") - 1 ); 

	$parteX2 = substr($valorX2, index($valorX2,"E") + 2, length($valorX1));	
	$valorX2 = substr($valorX2, 0, index($valorX2,"E") - 1 ); 

	$parteY1 = substr($valorY1, index($valorY1,"E") + 2, length($valorY1));	
	$valorY1 = substr($valorY1, 0, index($valorY1,"E") - 1 ); 

	$parteY2 = substr($valorY2, index($valorY2,"E") + 2, length($valorY2));	
	$valorY2 = substr($valorY2, 0, index($valorY2,"E") - 1 );

	if ($parteX1 == "00") {
	  $valorX1 = substr($valorX1, 0, 4);
	}else{
	  $valorX2 = substr($valorX2, index($valorX2,".") + 1, $parteX2) .".".  substr($valorX2, index($valorX2,".") + 2 , $parteX2 + 2);
	}

	if ($parteX2 == "00") {
	  $valorX2 = substr($valorX2, 0, 4);
	}else{
	  $valorX2 = substr($valorX2, index($valorX2,".") + 1, $parteX2) .".".  substr($valorX2, index($valorX2,".") + 2 , $parteX2 + 2);
	}

	if ($parteY1 == "00") {
	  $valorY1 = substr($valorY1, 0, 4);
	}else{
	  $valorY1 = substr($valorY1, index($valorY1,".") + 1, $parteY1) .".".  substr($valorY1, index($valorY1,".") + 2 , $parteY1 + 2);
	}

	if ($parteY2 == "00") {
	  $valorY2 = substr($valorY2, 0, 4);$deltaX
	}else{
	  $valorY2 = substr($valorY2, index($valorY2,".") + 1, $parteY2) .".".  substr($valorY2, index($valorY2,".") + 2 , $parteY2 + 2);
	}

	#print $valorX1;
	#print " ";
	#print $parteX1;
	#print " ";
	#print $valorX2;
	#print " ";
	#print $parteX2;

	#print " -- ";

	#print $valorX1;
	#print " ";
	#print $valorX2;
	#print " ";
	#print $valorY1;
	#print " ";
	#print $valorY2;
	#print " :  ";

	$deltaX = $valorX2 - $valorX1;
	$deltaY = $valorY2 - $valorY1;

	$dimensaoFractal = $deltaY/$deltaX;

	#print $deltaY; 
	#print " ";
	#print $deltaX;
	#print " ";
	#print $dimensaoFractal;

	#print $nomeArquivo;

	open(resultDF, ">>ResultDimensaoFractal.dat");
	print resultDF $nomeArquivo ." ". $dimensaoFractal . "\n";
	close(resultDF);
	
	print "\nArquivo " . $nomeArquivo . " finalizado \n\n";
}

sub ApagarTodos {

        @args = ("rm","ResultAnalise_7.dat");
        system(@args) == 0 or die "system @args failed: $?";

        @args = ("rm","ResultAnalise_8.dat");
        system(@args) == 0 or die "system @args failed: $?";

        @args = ("rm","ResultAnalise_9.dat");
        system(@args) == 0 or die "system @args failed: $?";

        @args = ("rm","ResultAnalise_10.dat");
        system(@args) == 0 or die "system @args failed: $?";

        @args = ("rm","ResultAnalise_11.dat");
        system(@args) == 0 or die "system @args failed: $?";

        @args = ("rm","ResultAnalise_13.dat");
        system(@args) == 0 or die "system @args failed: $?";

        @args = ("rm","tmad1.dat");
        system(@args) == 0 or die "system @args failed: $?";

        @args = ("rm","tmad2.dat");
        system(@args) == 0 or die "system @args failed: $?";

        @args = ("rm","tmad5.dat");
        system(@args) == 0 or die "system @args failed: $?";

        @args = ("rm","tmad6.dat");
        system(@args) == 0 or die "system @args failed: $?";

}

