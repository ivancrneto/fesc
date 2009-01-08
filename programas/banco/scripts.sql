

-- TABELAS

CREATE TABLE SEQUENCIA (
       ID_SEQ  	     BIGINT NOT NULL AUTO_INCREMENT, -- Chave primaria da tabela
       POSICAO       INTEGER, -- Posicao entre todas sequencias
       POSICAO_DNA   INTEGER, -- Posicao entre sequencias de DNA
       POSICAO_PRO   INTEGER, -- Posicao entre sequencias de proteinas
       POSICAO_COM   INTEGER, -- Posicao entre sequencias completas de DNA
       LOCUS         VARCHAR(50), -- Locus
       DEFINITION    VARCHAR(1000), -- Texto descritivo da sequencia
       GI            VARCHAR(50), -- ID unico no GenBank
       KEYWORDS      VARCHAR(1000), -- Palavras chave da sequencia no GanBank
       ORGANISM      VARCHAR(1000), -- Classificacao taxonomica do organismos
       ORGANISM_NAME VARCHAR(50), -- Nome do organismos que a sequencia foi extraida
       ARQ           VARCHAR(50), -- Nome do arquivo utilizado para armazenar as sequencias
       ALPHABET      VARCHAR(10), -- Tipo de sequencia DNA ou Protein
       COMPLETE_SEQ  VARCHAR(1), -- Flag que define se a sequencia eh completa
       SEQ           LONGTEXT, -- Sequencia
       PRIMARY KEY   (ID_SEQ)
);

CREATE TABLE SIMILARIDADE (
       ID_SIMILARIDADE 	 BIGINT NOT NULL AUTO_INCREMENT, -- Chave primaria da tabela
       COD_SEQ_ALVO      BIGINT, -- Codido da sequencia que vai ser comparada (PK da tabela SEQUENCIA)
       COD_SEQ_SIMILIAR  BIGINT, -- Codido da sequencia similar a comparda
       PERCENTUAL  	 FLOAT(7,4), -- percentual de similaridade
       SCORE  		 INT, -- Score da similaridade
       EVALUE 		 FLOAT(40,30), -- 
       LENGTH 	 	 INT, --
       GAPS 	 	 INT, --
       FRAC_IDENTICAL 	 FLOAT(40,30), --
       FRAC_CONSERVED 	 FLOAT(40,30), --
       N 	 	 INT, --
       MATCHES 	 	 INT, --
       NUM_IDENTICAL 	 INT, --
       NUM_CONSERVED 	 INT, --
       PRIMARY KEY 	 (ID_SIMILARIDADE)
);
select count(*) as result from SEQUENCIA WHERE COMPLETE_SEQ = '1' AND ALPHABET = 'DNA' AND length(SEQ) > 0
ALTER TABLE SIMILARIDADE ADD foreign key(COD_SEQ_ALVO) references SEQUENCIA(ID_SEQ);


-- procedures 

DELIMITER //
CREATE PROCEDURE pr_sequencias(IN lo varchar(50), IN df varchar(1000), IN gi VARCHAR(50), IN ky VARCHAR(1000), IN og VARCHAR(1000), IN seq LONGTEXT, IN ar VARCHAR(50), IN alf VARCHAR(10))
BEGIN
	
	insert into SEQUENCIA (LOCUS, DEFINITION, GI, KEYWORDS, ORGANISM, SEQ, ARQ, ALPHABET) values (lo, df, gi, ky, og, seq, ar, alf);
	
END
//
DELIMITER;


DELIMITER //
CREATE PROCEDURE pr_similaridade(IN ca varchar(200), IN cs VARCHAR(20), IN si VARCHAR(20), IN sc VARCHAR(20), IN ev VARCHAR(50), IN le VARCHAR(50), IN gap VARCHAR(50), IN fri VARCHAR(50), IN frc VARCHAR(50), IN n VARCHAR(50), IN mat VARCHAR(50), IN nui VARCHAR(50), IN nuc VARCHAR(50))
BEGIN
	
	IF (NOT EXISTS (SELECT 1 FROM SEQUENCIA, SIMILARIDADE WHERE ID_SEQ = ca AND COD_SEQ_SIMILIAR = cs AND ID_SEQ = COD_SEQ_ALVO) ) THEN
		insert into SIMILARIDADE (COD_SEQ_ALVO, COD_SEQ_SIMILIAR, PERCENTUAL, SCORE, EVALUE, LENGTH, GAPS, FRAC_IDENTICAL, FRAC_CONSERVED, N, MATCHES, NUM_IDENTICAL, NUM_CONSERVED) values (ca, cs, si, sc, ev, le, gap, fri, frc, n, mat, nui, nuc);
	END IF; 

END
//


DELIMITER;




