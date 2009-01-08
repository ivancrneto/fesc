#!/usr/bin/perl

  $diretorio = "./";

  opendir(diretorio, "$diretorio");
  @lista = readdir(diretorio);
  closedir(diretorio);

  foreach $arquivo(@lista){

    if ( substr($arquivo, index($arquivo,"."), length($arquivo) ) eq ".seq1"){

      # processando arquivo
      @args = ("perl","readFile.pl", $arquivo,".");
      system(@args) == 0 or die "system @args failed: $?";

    }

  }
