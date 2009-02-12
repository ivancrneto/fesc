REAL ETIME,XXTIME,TARRAY(2)
      

c      comecando a contar tempo de cpu

        XXTIME=ETIME(TARRAY)
       
c      finalizando a contagem do tempo de cpu


999       XXTIME=ETIME(TARRAY)
       WRITE(11,1009) XXTIME/60.
1009   FORMAT(1X,'TEMPO DE EXECUCAO=',F15.4,'MINUTOS')
