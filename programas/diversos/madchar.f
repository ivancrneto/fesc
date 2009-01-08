c     programa madchar8
c     calcula propriedades de redes a partir de sua matriz de adjacencia
c     entra dados pela subrotina mad
c     calcula grau e coeficiente de aglomeração
c	calcula coeficiente de assortatividade e dimensão fractal da rede
c     espectros de produtos booleanos de matrizes de adjacencia
c	habilitou apoloniana e leitura externa de uma matriz qualquer
c	igual a madchar4 mas nao calcula o espectro

c      use portlib
      parameter(nvm=30,npm=10000)
c      double precision am(npm,npm),ar(npm),ai(npm)
      integer*2 am(npm,npm)
c      double precision set1(npm,nvm),sord(npm,1)
      integer lar(npm), pro(npm), kk(0:npm,0:nvm),ic(0:npm)         
      real ga(0:npm), kmedio(0:nvm),rk(0:nvm)
      real gamedio(0:nvm),Lmedio(0:npm),set(npm,nvm),dfr(1000,0:2)
      character*30 entrada,saida7,saida8,saida9,saida10,saida11,saida12
      character*30 saida13
	character*13 saida

      open (unit=3,file='emadch.dat')

c     irede: identifica o tipo de rede: 
c     0-tridiagonal
c     1-small world
c     2-randomica
c     3-scale free
c     4-apolonia
c     5-le matriz em arquivo

c     nm:numero de nos na rede, no caso apoloniano, nm é inicialmente ng, a geração
c     ns:numero de amostras
c     np:potencia booleana maxima
c     ic:controle de escrita da matriz no arquivo de saida: 
c     ic(0)=0, não escreve matriz de adjacencia para controle e uso futuro
c	ic(0)>0, escreve ic(0) matrizes, a serem salvas nos passos ic(1), ic(2), ....
c	ipond=0, não escreve matriz ponderada,  ipond>0, escreve

c	entrada de dados
c==================================================================

10    read (3,*)irede,nm,ns,np,ic(0),ipond

	if (irede.lt.0)stop

      read (3,500)entrada
	read (3,505)saida
	read (3,*)npula

	saida7 = saida//'_7.dat'
	saida8 = saida//'_8.dat'
	saida9 = saida//'_9.dat'
	saida10 = saida//'_10.dat'
	saida11 = saida//'_11.dat'
	saida12 = saida//'_12.dat'
	saida13 = saida//'_13.dat'

c==================================================================
c	se ic(0)>0, le valores de ic(i>0) quando as matrizes serão salvas

      if (ic(0).gt.0) then
	 read (3,*)(ic(i),i=1,ic(0))
       open (unit=12,file=saida12)
	 icc = 1
	endif

c==================================================================
c     arquivo de entrada

c	entrada: guarda a matriz de adjacencia durante todo o programa

c     arquivos de saida: resultados para  valores de ip=1,..,np e is=1,...,ns

c	saida7: coeficiente de clusterização
c	saida8: distribuição de nos
c	saida9: distancia minima média por cada no e a distancia minima media da rede
c	saida10: espectro de nos em 
c	saida11: matriz adjacencia ponderada
c	saida13: dados para calculo da dimensão fractal
c==================================================================

      open (unit=4,file=entrada)
      open (unit=7,file=saida7)
      open (unit=8,file=saida8)
      open (unit=9,file=saida9)
      open (unit=10,file=saida10)
      open (unit=11,file=saida11)
      open (unit=13,file=saida13)

      intime = time()
      xtime = rand(intime)

c==================================================================
c	comeco do grand loop no numero de amostras
c==================================================================
      do is = 1,ns

c==================================================================
c	coloca zero nas diversas variáveis

	 do	i = 1,nm
	  ga(i) = 0.
	  Lmedio(i) = 0.
        do j = 1,nvm
	   set(i,j) = 0.
	   kk(i,j) = 0
	   kmedio(j) = 0.
	   gamedio(j) = 0.
	  enddo
	 enddo

	 npp = np

c==================================================================
c	gera a rede

      if (irede.eq.0) then
        call tridi(am,nm,npm)
       else if (irede.eq.1) then
        read (3,*)pc       
	write(10,*)pc
        call smalw(am,nm,npm,pc)
       else if (irede.eq.2) then 
        read (3,*)pc       
        call rando(am,nm,npm,pc)
       else if (irede.eq.3) then
        read (3,*)pc       
        call scafr(am,nm,npm)
       else if (irede.eq.4) then
        call apolo(am,nm,ng,npm)
       else if (irede.eq.5) then
	  open (unit=4,file=entrada)

	 do i = 1,npula
	  read(4,*)
	 enddo

	  do i = 1,nm
	   read(4,510)(lar(j),j=1,nm)
c	   write(*,510)(lar(j),j=1,nm)
	   do j = 1,nm
	    am(i,j) = dfloat(lar(j))
	   enddo
	  enddo
        close(unit=4)
      endif
	write(10,*)pc


c==================================================================
c	escreve mad am(i,j) em entrada

      if (irede.ne.5) then
       open (unit=4,file=entrada)

       do i = 1,nm
        write(4,510)(int(am(i,j)),j = 1,nm)
       enddo

       close(unit=4)
        write(7,510)

      endif

c==================================================================
c	se ipond>0, prepara para imprimir a matriz ponderada em tmad1.dat

       if (ipond.gt.0)then

        open(unit=1,file='tmad1.dat',form='unformatted')

     	  do i = 1,nm
	   write(1)(int(am(i,j)),j=1,nm)
	  enddo

	  close(unit=1)
	 endif

      write(7,510)

c==================================================================
c     soma matriz identidade com mad e coloca matriz com todos os vizinhos em tmad0
c     coloca matriz ad em tmad2

c	write(10,*) "soma matriz identidade..."

c      open(unit=5,file='tmad5.dat')
       open(unit=5,file='tmad5.dat',form='unformatted')

       do i = 1,nm
        do j = 1,nm
         lar(j) = int(am(i,j))
        enddo
        lar(i) = 1
c        write(5,510)(lar(j),j=1,nm)
        write(5)(lar(j),j=1,nm)
       enddo
 
       close(unit=5)
c	 write(10,*) "somado."

c==================================================================
c     comeca o loop para calculo as propriedades das diferentes matrizes
c	mad(ip)

       do ip = 1,np
       
	 write(10,*)'ip=',ip
	 write(10,*)
c==================================================================
c	se ic(0)>0, verifica e imprime matrizes para ip(i>0)  em saida12

       if (ic(0).gt.0)then

	  if(ic(icc).eq.ip)then 

	   write(12,*)'ip = ',ip
	   do i = 1,nm
          write(12,510)(int(am(i,j)),j = 1,nm)
         enddo
	   icc = icc + 1
	  endif

	 endif
c==================================================================
c     calcula coeficiente de clusterização e grau da matriz mad(ip)
c     calcula tambem o grau de assortatividadeda rk matriz mad(ip)
       
	  write(10,*) "Inicio do calculo de grau e aglomeracao...",ip
        call rede1(am,nm,npm,nvm,kk,ga,ip)
c	  write(10,*) "fim do calculo de grau e aglomeracao...",ip
	  write(10,*) "Feito."
	  write(10,*)

c        if (ip.eq.1) then
         gamedio(ip) = ga(0)/nm
         do i = 1,nm
          set(i,ip) = ga(i)
         enddo
c	   endif 
        call assorta(am,nm,npm,nvm,kk,ip,rrk)
	   rk(ip) = rrk
        kmedio(ip) = float(kk(0,ip))/nm

	  do i = 1,nm
	   Lmedio(i)= Lmedio(i) + kk(i,ip)*ip
	  enddo

c==================================================================
c     nao calcula espectro para matriz mad(ip)

c       if (kk(0,ip).eq.0) then
c        open(unit=9,file='tmad2.dat')
c        do i = 1,nm
c         read (9,510)(lar(j),j=1,nm)
c	   do j = 1,nm
c	    am(i,j) = dfloat(lar(j))
c	   enddo
c        enddo
c	 endif

c        call delmhes(am,nm,npm)
c        call dhqr(am,nm,npm,ar,ai)
        
c        do i = 1,nm
c         sord(i,1) = ar(i)
c        enddo
                   
c     ordena e normaliza o espectro
c        call orderset(sord,nm,1,1)

c        do i = 1,nm
c        set(i,ip) = sord(i,1)/sord(1,1)
c         set1(i,ip) = sord(i,1)
c        enddo

c==================================================================
c     desvio para finalizar o programa

        if (kk(0,ip).eq.0) go to 100

        if (ip.eq.np) go to 100

c==================================================================
c     comeca a obtencao de am**ip
c     le mad e transfere para am

        open (unit=4,file=entrada)

	  do i = 1,npula
	   read(4,*)
	  enddo

        do i = 1,nm
         read (4,510)(lar(j),j=1,nm)
         do j = 1,nm
          am(i,j) = dfloat(lar(j))
         enddo
        enddo
        close(unit=4)
c	  write(10,*)'aa'       

c==================================================================
c     le a matriz tmad5 faz pb tmad5*mad e guarda resultado em tmad6

        open(unit=5,file='tmad5.dat',form='unformatted')
        open(unit=6,file='tmad6.dat',form='unformatted')

        do i = 1,nm
        
c	   read (5,510)(lar(j),j=1,nm)
	   read (5)(lar(k),k=1,nm)

         do j = 1,nm
	    if (lar(j).eq.1) then
	     pro(j) = 1
	    else
          
		 pro(j) = 0
		 do k = 1,nm
            pro(j) = pro(j)+lar(k)*am(k,j)
           enddo
           pro(j) = min(1,pro(j))
	    
		endif
         enddo
c	  pro(i) = 1
c         write(6,510)(pro(j),j=1,nm)
         write(6)(pro(j),j=1,nm)
        enddo
      
        close(unit=6)
        close(unit=5)

	  write(10,*)'t1'

c==================================================================
c     obtem a nova matriz com vizinhos exclusivos de ordem ip+1: am=tmad6-tmad5

        open(unit=5,file='tmad5.dat',form='unformatted')
        open(unit=6,file='tmad6.dat',form='unformatted')
      
        do i = 1,nm

c         read (5,550)(lar(j),j=1,nm)
         read (5)(lar(j),j=1,nm)
c         read (6,550)(pro(j),j=1,nm)
         read (6)(pro(j),j=1,nm)

         do j = 1,nm
          am(i,j) = dfloat(pro(j)-lar(j))
         enddo

        enddo

        close(unit=6)
        close(unit=5)

c	  write(10,*)'t2'

c==================================================================
c     transfere a nova matriz com todos os vizinhos de tdma1 para tdma0

        open(unit=5,file='tmad5.dat',form='unformatted')
        open(unit=6,file='tmad6.dat',form='unformatted')

        do i = 1,nm
c         read (6,550)(lar(j),j=1,nm)
         read (6)(lar(j),j=1,nm)
c         write(5,550)(lar(j),j=1,nm)
         write(5)(lar(j),j=1,nm)
        enddo

        close(unit=6)
        close(unit=5)
      
c	  write(10,*)'t3'
     
c=====================================================
c	se ipond>0, atualiza a matriz de adjacencia ponderada
c     le tmad1, soma (ip+1)*am e coloca em tmad2

	  if (ipond.gt.0)then

         open(unit=1,file='tmad1.dat',form='unformatted')
         open(unit=2,file='tmad2.dat',form='unformatted')

         do i = 1,nm
          read (1)(lar(j),j=1,nm)
	    do j = 1,nm
	     lar(j) = lar(j)+am(i,j)*(ip+1)
	    enddo
	    write(2)(lar(j),j = 1,nm)
c	write(10,*)(lar(j),j = 1,nm)
c	pause
         enddo

         close(unit=2)
         close(unit=1)

c     transfere a nova matriz com todos os vizinhos ponderados de tmad2 para tmad1

         open(unit=1,file='tmad1.dat',form='unformatted')
         open(unit=2,file='tmad2.dat',form='unformatted')

         do i = 1,nm
          read (2)(lar(j),j=1,nm)
          write(1)(lar(j),j=1,nm)
         enddo

         close(unit=2)
         close(unit=1)
      
	  endif

c======================================================
c     fim do loop em ip
      enddo

c======================================================
c     saida dos resultados para a amostra is

100   npp = ip - 1

c======================================================
c	calcula a ordem de sub-grafo de cada no

       open(unit=5,file='tmad5.dat',form='unformatted')
       do i = 1,nm
        read (5)(lar(j),j=1,nm)
        do j = 1,nm
         am(i,j) = lar(j)
        enddo
       enddo
       close(unit=5)

       do i = 1,nm
	  kk(i,0) = 0													  
	  do j = 1,nm
	   kk(i,0) = kk(i,0) + am(i,j)
 	  enddo
	 enddo

c======================================================
c	se ipond>0 escreve a soma ponderada de matrizes de adjacencia formatada
c	e transfere a matriz ponderada para o campo am(np,np)

	 if(ipond.gt.0) then 

        open(unit=1,file='tmad1.dat',form='unformatted')
        open(unit=11,file=saida11)

        write(11,*)'matriz ponderada para = 1, ...',np,' e 
     .  pc = ',pc
        write(11,*)'is = ',is,'  irede = ',irede,' e nm = ',nm
        
	  do i = 1,nm
c         read (1,550)(lar(j),j=1,nm)
         read (1)(lar(j),j=1,nm)
c         write(1,550)(lar(j),j=1,nm)
         write(11,550)(lar(j),j=1,nm)
	   
	   do j = 1,nm
	    am(i,j) = lar(j)
	   enddo

        enddo

	  close(unit=1)
	  close(unit=2)

c	   write(10,*)
c	   write(10,*)(am(1,j),j=1,nm)
c	   write(10,*)

	  call fracnet(am,nm,npm,npp,dfr)

        write(13,*)'dados para cálculo da dimensão fractal' 

	  do i = 1,npp
	   write(13,540)dfr(i,1),dfr(i,2)
	  enddo

	 endif

c======================================================
c	escreve coeficiente de clusterização em saida7

       write(7,*)'coeficiente de clusterização para np = 1, ...',np,' e 
     . pc = ',pc
       write(7,*)'is = ',is,'  irede = ',irede,' e nm = ',nm
       write(7,540)(gamedio(k),k=1,npp+1)
       do j = 1,nm
        write(7,520)j,(set(j,k),k=1,npp+1)
       enddo

c======================================================
c	escreve distribuição de nos em saida8
c	escreve coeficientes de assortatividade em saida8

       write(8,*)'coeficientes de assortatividade para 
     . np = 1, ...',np,' e pc = ',pc
	 write(8,540)(rk(i),i=1,npp)


       write(8,*)'distribuição de nos para np = 1, ...',np,' e pc = ',pc
       write(8,*)'is = ',is,'  irede = ',irede,' e nm = ',nm
       write(8,540)(kmedio(k),k=1,npp+1)
       do j = 1,nm
        write(8,530)j,(kk(j,k),k=0,npp+1)
       enddo

c======================================================
c	calcula a distancia minima média por cada no e a distancia minima media da rede
c	escreve resultados em saida9
c	escreve coeficientes de assortatividade em saida9

	 xlmedio = 0.
	 ylmedio	= 0.
	 zlmedio	= 0.
	 nm2 = nm*nm
	 
	 do i = 1,nm
	  xlmedio	= xlmedio + Lmedio(i)/nm2
	  ylmedio = ylmedio + Lmedio(i)/kk(i,0)/kk(i,0)
	  zlmedio = zlmedio + Lmedio(i)/kk(i,0)/nm
	 enddo

       write(9,*)'distancia minima  para np = 1, ...',np,' e pc = ',pc
       write(9,*)'is = ',is,'  irede = ',irede,' e nm = ',nm
       write(9,540)xlmedio,ylmedio,zlmedio
       do i = 1,nm
        write(9,520)i,Lmedio(i)/nm,Lmedio(i)/kk(i,0)
       enddo

c======================================================
c	escreve espectro de nos em saida10

c       write(10,*)'espectro normalizado, np = 1, ...',np,' e pc = ',pc
c       write(10,*)'is = ',is,'  irede = ',irede,' e nm = ',nm

c       do j = 1,nm
c        write(10,520)j,(set1(j,k),k=1,npp+2)
c       enddo

c     fim do loop em is
         
c=====================================================================
      enddo

      close(unit=4)
      close(unit=7)
      close(unit=8)
      close(unit=9)
c      close(unit=10)
      close(unit=11)
	close(unit=12)      
	close(unit=13)      

	goto 10

500   format(a30)
505   format(a13)
510   format(10000i1)
c510   format(1096i2)
520   format(i5,300(2x,e13.7))     
530   format(i5,300(1x,i4))     
540   format(300(2x,e13.7))     
550   format(8768i4)

      end
            
c=====================================================================
c=====================================================================

      SUBROUTINE delmhes(a,n,np)
      INTEGER n,np
      DOUBLE PRECISION a(np,np)
      INTEGER i,j,m
      DOUBLE PRECISION x,y
      do 17 m=2,n-1
        x=0.d0
        i=m
        do 11 j=m,n
          if(abs(a(j,m-1)).gt.abs(x))then
            x=a(j,m-1)
            i=j
          endif
11      continue
        if(i.ne.m)then
          do 12 j=m-1,n
            y=a(i,j)
            a(i,j)=a(m,j)
            a(m,j)=y
12        continue
          do 13 j=1,n
            y=a(j,i)
            a(j,i)=a(j,m)
            a(j,m)=y
13        continue
        endif
        if(x.ne.0.d0)then
          do 16 i=m+1,n
            y=a(i,m-1)
            if(y.ne.0.d0)then
              y=y/x
              a(i,m-1)=y
              do 14 j=m,n
                a(i,j)=a(i,j)-y*a(m,j)
14            continue
              do 15 j=1,n
                a(j,m)=a(j,m)+y*a(j,i)
15            continue
            endif
16        continue
        endif
17    continue
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software 21A241=$iD#.01d0.d0


c=====================================================================
c=====================================================================

      SUBROUTINE dhqr(a,n,np,wr,wi)
      INTEGER n,np
      DOUBLE PRECISION a(np,np),wi(np),wr(np)
      INTEGER i,its,j,k,l,m,nn
      DOUBLE PRECISION anorm,p,q,r,s,t,u,v,w,x,y,z
      anorm=abs(a(1,1))
      do 12 i=2,n
        do 11 j=i-1,n
          anorm=anorm+abs(a(i,j))
11      continue
12    continue
      nn=n
      t=0.d0
1     if(nn.ge.1)then
        its=0
2       do 13 l=nn,2,-1
          s=abs(a(l-1,l-1))+abs(a(l,l))
          if(s.eq.0.d0)s=anorm
          if(abs(a(l,l-1))+s.eq.s)goto 3
13      continue
        l=1
3       x=a(nn,nn)
        if(l.eq.nn)then
          wr(nn)=x+t
          wi(nn)=0.d0
          nn=nn-1
        else
          y=a(nn-1,nn-1)
          w=a(nn,nn-1)*a(nn-1,nn)
          if(l.eq.nn-1)then
            p=0.5d0*(y-x)
            q=p**2+w
            z=sqrt(abs(q))
            x=x+t
            if(q.ge.0.d0)then
              z=p+sign(z,p)
              wr(nn)=x+z
              wr(nn-1)=wr(nn)
              if(z.ne.0.d0)wr(nn)=x-w/z
              wi(nn)=0.d0
              wi(nn-1)=0.d0
            else
              wr(nn)=x+p
              wr(nn-1)=wr(nn)
              wi(nn)=z
              wi(nn-1)=-z
            endif
            nn=nn-2
          else
            if(its.eq.30)pause 'too many iterations in hqr'
            if(its.eq.10.or.its.eq.20)then
              t=t+x
              do 14 i=1,nn
                a(i,i)=a(i,i)-x
14            continue
              s=abs(a(nn,nn-1))+abs(a(nn-1,nn-2))
              x=0.75d0*s
              y=x
              w=-0.4375d0*s**2
            endif
            its=its+1
            do 15 m=nn-2,l,-1
              z=a(m,m)
              r=x-z
              s=y-z
              p=(r*s-w)/a(m+1,m)+a(m,m+1)
              q=a(m+1,m+1)-z-r-s
              r=a(m+2,m+1)
              s=abs(p)+abs(q)+abs(r)
              p=p/s
              q=q/s
              r=r/s
              if(m.eq.l)goto 4
              u=abs(a(m,m-1))*(abs(q)+abs(r))
              v=abs(p)*(abs(a(m-1,m-1))+abs(z)+abs(a(m+1,m+1)))
              if(u+v.eq.v)goto 4
15          continue
4           do 16 i=m+2,nn
              a(i,i-2)=0.d0
              if (i.ne.m+2) a(i,i-3)=0.d0
16          continue
            do 19 k=m,nn-1
              if(k.ne.m)then
                p=a(k,k-1)
                q=a(k+1,k-1)
                r=0.d0
                if(k.ne.nn-1)r=a(k+2,k-1)
                x=abs(p)+abs(q)+abs(r)
                if(x.ne.0.d0)then
                  p=p/x
                  q=q/x
                  r=r/x
                endif
              endif
              s=sign(sqrt(p**2+q**2+r**2),p)
              if(s.ne.0.d0)then
                if(k.eq.m)then
                  if(l.ne.m)a(k,k-1)=-a(k,k-1)
                else
                  a(k,k-1)=-s*x
                endif
                p=p+s
                x=p/s
                y=q/s
                z=r/s
                q=q/p
                r=r/p
                do 17 j=k,nn
                  p=a(k,j)+q*a(k+1,j)
                  if(k.ne.nn-1)then
                    p=p+r*a(k+2,j)
                    a(k+2,j)=a(k+2,j)-p*z
                  endif
                  a(k+1,j)=a(k+1,j)-p*y
                  a(k,j)=a(k,j)-p*x
17              continue
                do 18 i=l,min(nn,k+3)
                  p=x*a(i,k)+y*a(i,k+1)
                  if(k.ne.nn-1)then
                    p=p+z*a(i,k+2)
                    a(i,k+2)=a(i,k+2)-p*r
                  endif
                  a(i,k+1)=a(i,k+1)-p*q
                  a(i,k)=a(i,k)-p
18              continue
              endif
19          continue
            goto 2
          endif
        endif
      goto 1
      endif
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software 21A241=$iD#.01d0.d0
      

c=====================================================================
c=====================================================================

      subroutine orderset(set,n,m,icol)
c     it orders, descending, a set of numbers, conserving the respective
c     positions of other sets
c     icol indicates the column which will be considered for the ordering  

      double precision set(n,m),x1 
      itera = 0
10    icont = 0

      itera = itera + 1

      do  20  j= 1,n-1

c      to order in ascending order use the following command
c      if (set(j,icol).gt.set(j+1,icol)) then

c      to order in descending order use the following command
      if (set(j,icol).lt.set(j+1,icol)) then

      icont = 1
      do k = 1,m
      x1 = set(j,k)
      set(j,k) = set(j+1,k)
      set(j+1,k) = x1
      enddo

      endif

20    continue

      if (icont.ne.0) go to 10

      return
      
      end      


c=====================================================================
c=====================================================================

      subroutine rede1(a,n,npm,nvm,kk,ga,ip)

c      parameter(nvm=30,npm=10000)
      integer n,npm,i,j,kk(0:npm,0:nvm)
c      double precision a(npm,npm)
      integer*2 a(npm,npm)
      real ga(0:npm)
	integer vVz(npm),linha
	real cLocal,cTotal,sumG,ordem


c     calcula o grau de cada no
      kk(0,ip) = 0
      do i=1,n
       kk(i,ip)=0
       do j=1,n
        kk(i,ip) = kk(i,ip) + a(i,j)
       enddo
      kk(0,ip) = kk(0,ip) + kk(i,ip)
      enddo
	
c	if (ip.gt.1) return

c     calcula o coeficiente de aglomeração de cada noh
      ga(0) = 0.
	write(10,*) "em rede 1 Calculando coef. de aglomeracao..."
	do i=1,n
	write(10,*) "i=",i
		do j=1,n  
			vVz(j) = -1
		enddo
	
		ordem = 0
		do j=1,n
			if (a(i,j) .eq. 1) then
				ordem=ordem+1
				vVz(ordem) = j
			endif
		enddo

		cTotal = ((ordem * (ordem-1))/2)
		sumG=0
		do j=1,ordem
			linha=vVz(j)
			do k=1,n
	if (a(linha,k).eq.1.and.a(i,k).eq.1.and.linha.ne.k.and.k.ne.i)then								      
					sumG=sumG+1
				endif
			enddo
		enddo
		cLocal = (sumG)/2	
		if (cTotal .gt. 0) then
			ga(i) = cLocal/cTotal
		else
			ga(i)=0
		endif
		ga(0) = ga(0) + ga(i)
      enddo 

      return
      end

c=====================================================================
c=====================================================================

      subroutine tridi(a,n,np)
      integer n,np,i,j
      integer*2 a(np,np)
c      double precision a(np,np)

      do i = 1,n
       do j = 1,n
        a(i,j) = 0
       enddo
      enddo

      do i = 1,n-1
       a(i,i+1) = 1
       a(i+1,i) = 1
      enddo

c	se os valores são 1, cadeia fechada, se são 0, cadeia aberta

      a(1,n) = 0
      a(n,1) = 0

      return
      end

c=====================================================================
c=====================================================================

      subroutine smalw(a,n,np,pc)
      integer n,np,i,j
      integer*2 a(np,np)
c      double precision a(np,np)
      real pc
      
c      use portlib
      
c      intime = time()
c      xtime = rand(intime)

      do i = 1,n
       do j = 1,n
        a(i,j) = 0
       enddo
      enddo

      do i = 1,n-2
       a(i,i+1) = 1
       a(i+1,i) = 1
	 a(i+2,i) = 1
	 a(i,i+2) = 1
      enddo

      a(1,n) = 1
      a(n,1) = 1

c      intime = time()
c      xtime = rand(intime)

      do i = 1,n
       x1 = rand(0)
       if (x1.lt.pc) then
        j1 = int(rand(0)*n+1)
c        a(i,i+1) = 0
c        a(i+1,i) = 0
        a(i,j1) = 1
        a(j1,i) = 1
       endif
      enddo

      do i = 1,n
       a(i,i) = 0
      enddo

      return
      end

c=====================================================================
c=====================================================================

      subroutine rando(a,n,np,pc)
      integer n,np,i,j
      integer*2 a(np,np)
c      double precision a(np,np)
      real pc

c      use portlib

c      intime = time()
c      xtime = rand(intime)

      xlb = 2*n
      xup = n*sqrt(float(n))

c     aqui o numero de conexoes pode variar a cada amostra
      xt = rand(0) 
      nt = int(xlb + xt*(xup-xlb))

c     aqui o numero de conexoes é fixo = pc*nm
      if (pc.gt.0) nt = pc * n * (n-1) / 2

      do i = 1,n
       do j = 1,n
        a(i,j) = 0
       enddo
      enddo

      do i = 1,nt
       i1 = int(rand(0)*n+1)
       j1 = int(rand(0)*n+1)
       a(i1,j1) = 1
       a(j1,i1) = 1
      enddo

      do i = 1,n
       a(i,i) = 0
      enddo

      return
      end
c=====================================================================
c=====================================================================

      subroutine scafr(ma,nVert,npm)
      integer npm,nVert,i,j,k,NosAleat,nNos,Tgraus
      integer*2 ma(npm,npm)
c      double precision ma(npm,npm),Pr
c	   O parametro M deve ser no minimo 4	
      parameter (M=4)
	integer grau(nVert)

c	Programa NetScaleFree
c	Gera uma rede do tipo scale free

	i=0
	j=0
	k=0
c	write(10,*) "construindo rede scale-free..."
c		// Numero de nos aleatorios iniciais 
	NosAleat=M
c		// Numero total de arestas do grafo
	nNos=0
	Tgraus=0


	do i=1,nVert
		grau(i) = 0
		do j=1,nVert
			ma(i,j) = 0
		enddo
	enddo
c		// Gera pequena rede aleatoria inicial
	
      NosAleat=M
	nNos=1
	do i=2,NosAleat
		do k=1,nNos
			j=int(rand(0)*nNos+1)
			if (i .ne. j .and. ma(i,j) .eq. 0) then
				ma(i,j)=1
				ma(j,i)=1
				grau(i)=grau(i)+1
				grau(j)=grau(j)+1
				Tgraus=Tgraus+2
			endif
		enddo
		nNos=nNos+1
	enddo


	
c	// Varre o restante do Grafo conectando os vertices
	do i=NosAleat+1,nVert
c		// M arestas para cada nó novo

		k=M
		do while(k .gt. 0)
			j=int(rand(0)*(nNos)+1)

c			// probabilidade de um nó ser conectado;
			Pr=float(grau(j))/Tgraus
			if (Pr.gt.rand(0).and. i .ne. j .and. ma(i,j) .eq. 0) then
				ma(i,j)=1
				ma(j,i)=1
				grau(i)=grau(i)+1
				grau(j)=grau(j)+1
				k=k-1
				Tgraus=Tgraus+2
			endif
		enddo
		nNos=nNos+1
	enddo
c	write(10,*) "feito."

	return
	end


c=====================================================================
c=====================================================================

      subroutine apolo(a,n,ngm,np)

      integer n,np,i,j,ng(n) 
c      double precision a(np,np)
      integer*2 a(np,np)

	ngm = n

      do i = 1,ngm
       ng(i) = (3**(i-1)+5)/2
      enddo
      
	n = ng(ngm)

      do i = 1,ng(ngm)
       do j = 1,ng(ngm)
        a(i,j) = 0
       enddo
      enddo  
      
      do i = 1,4
       do j = i+1,4
        a(i,j) = 1
        a(j,i) = 1
       enddo
      enddo  

      do ig = 3,ngm
      
       ng0 = ng(ig)
       ng1 = ng(ig-1)
       ng2 = ng(ig-2)
       ng3 = 2*ng1 - 3
       
       do i = 1,ng1 - 3
       do j = 1,ng1 - 3
       
        a(ng1+i,ng1+j) = a(2+i,2+j)
        a(ng3+i,ng3+j) = a(2+i,2+j)
        
       enddo
       enddo
       
       do j = 1,ng1 - 3
       
        a(1,ng1+j) = a(1,2+j)
        a(ng1,ng1+j) = a(ng1,2+j)
        a(ng0,ng1+j) = a(2,2+j)
        a(2,ng3+j) = a(2,2+j)
        a(ng1,ng3+j) = a(ng1,2+j)
        a(ng0,ng3+j) = a(1,2+j)

        
        a(ng1+j,1) = a(1,ng1+j)
        a(ng1+j,ng1) = a(ng1,ng1+j)
        a(ng1+j,ng0) = a(ng0,ng1+j)
        a(ng3+j,2) = a(2,ng3+j)
        a(ng3+j,ng1) = a(ng1,ng3+j)
        a(ng3+j,ng0) = a(ng0,ng3+j)

       enddo

        a(ng0,1) = a(ng1,1)
        a(ng0,2) = a(ng1,2)
        a(ng0,ng1) = a(ng1,ng2)
        
        a(1,ng0) = a(ng1,1)
        a(2,ng0) = a(ng1,2)
        a(ng1,ng0) = a(ng1,ng2)

      enddo
       
c      do i = 1,ng(ngm)
c       write(*,510)(int(a(i,j)),j=1,ng(ngm))
c      enddo

500   format (10000i1)
510   format (1x,10000i1)

      end

c=====================================================================
c=====================================================================

      subroutine assorta(a,n,np,nvm,kk,ip,rk)
      integer kk(0:np,0:nvm)
      integer*2 a(np,np)

	if(kk(0,ip).eq.0)return

	s1 = 0.
	s2 = 0.
	s3 = 0.
	na = 0

	do i = 1,n-1
	 do j = i+1,n
	  if (a(i,j).eq.1) then
	   s1 = s1 + kk(i,ip)+kk(j,ip)
	   s2 = s2 + kk(i,ip)*kk(j,ip)
	   s3 = s3 + kk(i,ip)*kk(i,ip)+kk(j,ip)*kk(j,ip)
	   na = na + 1
	  endif
	 enddo
	enddo

	s1 = s1/na
	s2 = s2/na
	s3 = s3/na

c	calcula coeficiente de assortatividade
	
	rkk = (0.5*s3 - (0.5*s1)**2)
      
	if (rkk.ne.0) rkk = (s2 - (0.5*s1)**2)/rkk

	rk = rkk
 
      return
      end

c=====================================================================
c=====================================================================

c	subroutine fracnet(am,nm,npm,npp,dfr)
	subroutine fracnet(a,n,np,diam,dfr)
c	subroutine fracnetwork(a,idiameter,n)
	
	integer*2 a(np,np)
	integer diam,fim
c	dimension dfr(1000,0:2),labelb(0:n,0:n),numberb(0:n)
	real dfr(1000,0:2)
	integer labelb(0:10000,0:10000),numberb(0:10000)

c	  do i = 1,n
c	   write(10,*)(a(1,j),j=1,n)
c	   pause
c	  enddo

	write(10,*)diam
	
      aux2 = diam
	aux = n

	do i = 1,diam
	 
	 dfr(i,1)=0
	 dfr(i,2)=0
	enddo

	do iref = 1,aux2

	do i = 0,n
	 numberb(i)=0
	 do j = 0,n
	  labelb(i,j)=0
	 enddo
	enddo

	 nbox = 0

	 do i = 1,n

	  if (nbox.eq.0) then
	   nbox = 1
c	   labelb(1,1) = 1+0
c	   numberb(1) = 1
 	   labelb(0,0) = 1
 	   numberb(0) = 1

	  else

	   j = 0
	   fim = 0

	   do while (j.lt.nbox.and.fim.eq.0)
	    fim = 0
c	    do k = 1,numberb(j)
          do k = 0,numberb(j)-1
	     if (a(i,labelb(k,j)).le.iref)then
	      fim = fim + 1
	     else
	      go to 100
	     endif
	    enddo

100	    continue

	    if (fim.eq.numberb(j)) then

	     fim = 1

	     labelb(numberb(j),j)= i
	     numberb(j)=numberb(j)+1

	    else

	     fim = 0

	    endif

	    j = j+1
	
         enddo 

	   if (fim.eq.0) then
c    labelb(1,nbox) = i
          labelb(0,nbox) = i
	    numberb(nbox) = numberb(nbox) + 1
	    nbox = nbox + 1

	   endif
	  endif
	 enddo

       dfr(iref,1)=log(float(iref+1));
	 dfr(iref,2)=log(float(nbox));

	enddo

	return

	end
c=====================================================================
