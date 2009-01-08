c     programa dendo2
c     calcula o dendograma de uma rede a partir da eliminação sucessiva
c      dos nós com maior grau de betweeness
c      faz renumeracao dinamica dos nos, de modo que todos os nos de um cluster
c      sejam numerados contiguamente
c      constroi arquivo para tracar dendograma no origin
c      entrada dos dados via matriz de vizinhança
c      usa rotina rannyu para gerar numeros aleatorios
c      duas maneiras de gerar sementes independentes, para windows e linux
c      igual a dendo1, mas calcula a distância entre duas matrizes de vizinhancas
c      após a eliminação de uma conexão

c      use portlib
      parameter(npm=3283,nml=1900000)
      integer icc(npm),iord(npm,4),ila(npm),inc(npm)
      integer am(npm,npm),bm(npm,npm),lar(npm)
      real cm(npm,npm),yc(0:npm)
      real etime,xxtime,tarray(2),intime,xtime,xi
      real*8 rannyu
      integer ie(nml),ig(0:nml),iv(2,nml)
      character*8 saida
      character*26 saida1,saida2,saida3,saida4,saida5,saida6,entrada4
      common /rnyucm/ mk1,mk2,mk3,mk4,km1,km2,km3,km4

c==================================================================
c      entrada4: matriz de vizinhança da rede
c     nm: numero de nos na rede
c      npula: numero de linhas antes dos elementos da matriz

c      saida1: informa, no minimo, a sequencia das conexoes eliminadas 
c              pode-se habilitar outras informaçoes sobre a evolucao do processo
c              contudo, para redes grandes, o arquivo pode tornar-se muito grande
c      saida2: informa o cluster ao qual cada nó pertence, para cada valor de itera
c              na ultima linha informa a numeracao inicial de cada nó
c      saida3: guarda a matriz de vizinhança com nós renumerados de acordo com a 
c              sequencia de eliminaçoes de conexoes
c      saida4: dados para o dendograma. 
c     saida5: coluna unica, com a mesma informacao que na ultima linha de saida2
c              usada para ilustrar dendograma feito com o origin
c     saida6: distancia entre duas matrizes de vizinhancas sucessivas em funcao de itera
c==================================================================

      xxtime=etime(tarray)
	write(*,*) xxtime, etime(tarray), tarray 

c      constantes para a rotina rnyucm e nao podem ser trocados
      mk1=0
      mk2=1
      mk3=3513
      mk4=821

c      sementes do aleatorio, devem ser trocados para cada run

      km1=3577 
      km2=5735
      km3=4689
      km4=9087

c      comandos para gerar semente aleatoria em linux

c5     jntime = time()

	write(*,*) jntime, time()

      km = jntime/10000
      km = jntime - km*10000

	write(*,*) km


c      aquecendo o rrand
c      comandos para gerar semente aleatoria em windows
c5     call seed(-1)
c      km = 10000*rand(0)

      km1 = km + km1
      km2 = (km + km2)*(km + km2)/km1
      km3 = (km + km3)*(km + km3)/km2
      km4 = (km + km4)*(km + km4)/km3

c      entrada de dados
c==================================================================
      open (unit=3,file='edendo.dat')

10    read (3,*,end=1000)nm,npula
      if(nm.lt.0)stop

      read (3,500)entrada4
      read (3,505)saida
      saida1 = 'd2'//saida//'1.dat'
      saida2 = 'd2'//saida//'2.dat'
      saida3 = 'd2'//saida//'3.dat'
      saida4 = 'd2'//saida//'4.dat'
      saida5 = 'd2'//saida//'5.dat'
      saida6 = 'd2'//saida//'6.dat'

c      entrada da matriz
c==================================================================

      open (unit=4,file=entrada4)
      open (unit=5,file=saida1)
      open (unit=6,file=saida2)
      open (unit=7,file=saida3)
      open (unit=8,file=saida4)
      open (unit=9,file=saida5)
      open (unit=10,file=saida6)
      open (unit=16,file='tempdendo1.dat',form='unformatted')
       
      open (unit=20,file='d2tempocpu.dat',access='append')

      do i = 1,npula
       read(4,*)
      enddo
         
      do i = 1,nm
       read(4,510)(lar(j),j=1,nm)
       do j = 1,nm
        am(i,j) = lar(j)
       enddo
      enddo

      close(unit=4)

c==================================================================
c      grava am em bm

      nlink = 0

      do i = 1,nm
       do j = 1,nm
        bm(i,j) = am(i,j)
        if (am(i,j).eq.1)nlink = nlink + 1
       enddo
      enddo

      nlink = nlink/2

      write (*,*)'nlink = ',nlink
      if (nlink.gt.nml)stop

c      do i = 1,nm
c       write(5,510)(am(i,j),j=1,nm)
c      enddo

c==================================================================
c      grava memoria do ordenamento inicial dos sitios

      do i = 1,nm
       iord(i,4) = i
      enddo

c      começa o grande loop para eliminação dos links com maior betweenness
c==================================================================

      id1 = 1
      itera = 0
      
      do while(id1.gt.0)

       itera = itera + 1

       if (itera.gt.nml)then
        write (*,*) 'itera>nml'
        stop
       endif

c      determina o diametro
c==================================================================

       do i = 1,nm
        do j = 1,nm
         cm(i,j) = 0.
        enddo
       enddo

       do i = 1,nm
        if (am(i,i).ne.0)write(*,*)itera,i,am(i,i)
        if (am(i,i).ne.0)write(5,*)itera,i,am(i,i)
       enddo

       id1 = 0
       do i = 1,nm
        do j = 1,nm
         if (am(i,j).gt.id1) id1 = am(i,j)
         if (am(i,j).eq.1)cm(i,j) = am(i,j)
        enddo
       enddo

c      comeca a calcular o grau de betweeness
c==================================================================

       do id = 1,id1-1
        i1 = id1 - id + 1 
       
        do i = 1,nm
         do j = i+1,nm
          if(am(i,j).eq.i1) then
           il = 0
           do l = 1,nm
            if (am(i,l).eq.1.and.am(j,l).eq.i1-1.or.
     .         am(j,l).eq.1.and.am(i,l).eq.i1-1) il=il + 1
           enddo
           if (il.gt.0) then
            do l = 1,nm
             if (am(i,l).eq.1.and.am(j,l).eq.i1-1.or.
     .          am(j,l).eq.1.and.am(i,l).eq.i1-1)then
               cm(i,l) = cm(i,l) + (cm(i,j) + 1.)/il 
               cm(j,l) = cm(j,l) + (cm(i,j) + 1.)/il 
                 cm(l,i) = cm(i,l)
               cm(l,j) = cm(j,l)
               endif
            enddo
           endif
          endif
         enddo
        enddo

       enddo

c      corrige matriz de betweenness
c==================================================================

       do i = 1,nm
        do j = 1,nm
         if (am(i,j).ne.1)cm(i,j)=0
        enddo
       enddo

c      procura o sitio      com o maior grau de betweeness
c=====================================================

       ib = 0
       inb = 0
       do i = 1,nm-1
        do j = i+1,nm
         if (am(i,j).eq.1) then
          ib1 = cm(i,j)
          if (ib1.gt.ib) then
           ib = ib1
           inb = 1
           iv(1,inb) = i
           iv(2,inb) = j
          else if (ib1.eq.ib) then
           inb = inb + 1
           iv(1,inb) = i
           iv(2,inb) = j
          endif
         endif
        enddo
       enddo

c      transfere a matriz am para cm
c=====================================================

       do i = 1,nm
        do j = 1,nm
         cm(i,j) = am(i,j)
        enddo
       enddo

c      elimina um link
c=====================================================

       if (inb.eq.1) then
        am(iv(1,inb),iv(2,inb)) = 0
        am(iv(2,inb),iv(1,inb)) = 0
        i1 = iv(1,inb)
        j1 = iv(2,inb)
       else if (inb.gt.1) then
        xt = rannyu()
        il = min(int(xt*inb)+1,inb)
        am(iv(1,il),iv(2,il)) = 0
        am(iv(2,il),iv(1,il)) = 0
        i1 = iv(1,il)
        j1 = iv(2,il)
       endif

       ie(1) = i1
       ie(2) = j1
       iv(1,1) = i1
       iv(2,1) = j1
       nie = 2
       nv = 1

c      calcula os efeitos da eliminacao do link (i1,j1)
c=====================================================

       write(5,*)' itera',itera,'    link eliminado', i1,j1
c       write(*,*)' itera',itera,'    link eliminado', i1,j1

       iel = 1

       do while (iel.ne.0)

        iel = iel + 1
        id = iel
        nnie = 0
        imid = 0

        do ili = 1,nie
         ia = ie(ili)
         do l = 1,nm
          if (am(ia,l).eq.id) then
           ip = 0
           do it = 1,nm
            if(am(ia,it).eq.1.and.am(l,it).eq.id-1.
     .        or.am(l,it).eq.1.and.am(ia,it).eq.id-1) ip = 1
           enddo
           if (ip.eq.0) then
            am(ia,l) = 0
            am(l,ia) = 0
            nnie = nnie + 1
            nv = nv + 1
            iv(1,nv) = min(ia,l)
            iv(2,nv) = max(ia,l)
            ie(nie+nnie) = l
            imid = 1
           endif
          endif
         enddo
        enddo
        nie = nie + nnie
       if (imid.eq.0.and.id.gt.id1) ied = iel
       if (imid.eq.0.and.id.gt.id1) iel = 0
       enddo
 
c      escreve a matriz com os links zerados por efeito da eliminacao do link (i1,j1) 
c==================================================================

c       write(5,*)'matriz com efeito propagado', itera,id1,i1,j1

c       do i = 1,nm
c        write(5,510)(am(i,j),j=1,nm)
c       enddo

c      reconstroi a matriz de vizinhança
c=====================================================

       iel = ied + 1
       iel = ied*0+2
       do while (iel.ne.0)
        id = 0
        do iiv = 1,nv
         i1 = iv(1,iiv)
         j1 = iv(2,iiv)
         if(am(i1,j1).eq.0) then
          id = 1
          ip = 0
          il = 1
          do while (ip.eq.0)
           do it = 1,nm
            if(am(i1,it).eq.il.and.am(j1,it).eq.iel-il.
     .      or.am(i1,it).eq.iel-il.and.am(j1,it).eq.il) ip = 1
           enddo
           if (ip.eq.1) am(i1,j1) = iel
           if (ip.eq.1) am(j1,i1) = iel
           il = il + 1  
           if (il.gt.iel-1) ip = npm+1
          enddo
         endif
        enddo
        iel = iel + 1
        if (iel.gt.2*ied.or.id.eq.0) iel = 0
       enddo

c      escreve a matriz resconstituida
c==================================================================

c       write(5,*)' matriz reconstituida   itera',itera
c       write(*,*)' matriz reconstituida   itera',itera
c       do i = 1,nm
c        write(5,510)(am(i,j),j=1,nm)
c       enddo
c       write(5,*)

c      calcula a distância entre duas matrizes sucessivas 
c==================================================================

       dist = 0

       do i = 1,nm-1
        do j = i,nm
         dist = dist + (cm(i,j) - am(i,j))**2
        enddo
       enddo

       dist = sqrt(dist)

c      identificação dos clusters
c==================================================================
       do i = 1,nm
        icc(i) = 0
        inc(i) = 0
       enddo

       id = 1
       nc = 0

       do i = 1,nm
        if(nc.lt.nm) then
         ic = 0
         do j = 1,nm
          if(icc(j).eq.0) then
           if(am(i,j).ne.0.or.i.eq.j) then
            icc(j) = id
            nc = nc + 1
            ic = 1
           endif
          endif
         enddo
         if (ic.eq.1) id = id + 1
        endif
       enddo
c       write(6,510)itera,(icc(k),k=1,nm)         

       incm = 0
       do i = 1,nm
        inc(icc(i)) = inc(icc(i)) + 1
        incm = max(incm,icc(i))
       enddo

       nden = 0
       do i = 1,incm
        nden = nden + inc(i)*(inc(i)-1)/2
       enddo

c      renumera os sitios
c==================================================================

       do i = 1,nm
        iord(i,1) = i
        iord(i,2) = icc(i)
       enddo

       call orderset(iord,nm,4,2)

       iwc = 0

       do i = 1,nm
        iord(i,3) = i
        ila(i) = i
       enddo

20       iw = 0
       iwc = iwc + 1
        do i = 1,nm
         if (iord(i,1).ne.iord(i,3)) then
          i1 = iord(i,1)
          i3 = iord(i,3)
          j1 = i
          j2 = ila(i1)
          do j = 1,nm
           if(j.ne.j2.and.j.ne.j1)then
            iw = 1
            mtemp = am(j1,j)
            am(j1,j) = am(j2,j)
             am(j2,j) = mtemp
            am(j,j1) = am(j1,j)
            am(j,j2) = am(j2,j)
            mtemp = bm(j1,j)
            bm(j1,j) = bm(j2,j)
             bm(j2,j) = mtemp
            bm(j,j1) = bm(j1,j)
            bm(j,j2) = bm(j2,j)
           endif
          enddo
          iord(ila(i1),3) = i3
          iord(i,3) = i1
          mtemp = ila(i1)
          ila(i1) = ila(i3)
          ila(i3) = mtemp

         endif
        enddo
       if (iw.eq.1) goto 20
 
       write(6,511)itera,(iord(k,2),k=1,nm)         
       write(10,512)itera,dist,dist/max(1,nden)
       write(16)itera,(iord(k,2),k=1,nm)         

c       write(5,*)' matriz reconstituida e renumerada'
c       write(5,*)

50      continue

       enddo

      nlink = itera

      write(7,*)' matriz de vizinhança renumerada'
      do i = 1,nm
       write(7,510)(bm(i,j),j=1,nm)
      enddo

      write(6,510)
      write(6,511)100,(iord(k,4),k=1,nm)         
 
      close(unit=5)
      close(unit=6)
      close(unit=7)
      close(unit=10)
      close(unit=16)

c      constroi dendograma
c==================================================================

c      identifica valores das coordenadas de cada cluster 
c==================================================================

      open (unit=16,file='tempdendo1.dat',form='unformatted')
      open (unit=17,file='tempdendo2.dat',form='unformatted')

      itera = 0
      ig(0) = 1
      xlm = 0.5*(1.+ float(nm))
      do k = ii,j-1
       yc(k) = xlm
      enddo

      write (17)itera,(yc(k1),k1=1,nm)

      do i = 1,nlink
       read (16)itera,(lar(k1),k1=1,nm)
       xlm = float(lar(1))
       ii = 1
       xne = 1.
       ig(i) = 1
       do j = 2,nm
        if(lar(j).eq.lar(j-1))then

         xlm = xlm*xne/(xne+1) + float(j)/(xne+1)
         xne = xne + 1

         if(j.eq.nm) then
          do k = ii,j
           yc(k) = xlm
          enddo
         endif

        else

         ig(i) = ig(i) + 1
         do k = ii,j-1
          yc(k) = xlm
         enddo
         xlm = float(j)
         ii = j
         xne = 1.
         if(j.eq.nm) yc(k) = xlm

        endif

       enddo

       write (17)itera,(yc(k1),k1=1,nm)

       do k = 1,nm
        yc(k) = 0.
       enddo

      enddo

      close(unit=16)
      close(unit=17)


c      insere linhas extras nos valores de bifurcação e escreve dendograma
c==================================================================

      open (unit=17,file='tempdendo2.dat',form='unformatted')

      do i = 0,nlink-1
       read (17)itera,(yc(k1),k1=1,nm)
       write(8,530)itera,(yc(k1),k1=1,nm)
       if(ig(i).lt.ig(i+1))write(8,530)itera+1,(yc(k1),k1=1,nm) 
      enddo

      read (17)itera,(yc(k1),k1=1,nm)
      write(8,530)itera,(yc(k1),k1=1,nm)

      open (unit=9,file=saida5)

      do i = 1,nm
       write(9,511)iord(i,4)
      enddo

      close(unit=8)
      close(unit=9)

      xxtime=etime(tarray)

      write(20,540)is,irede,nm,xxtime/60.


500   format(a26)
505   format(a8)
510   format(10000i4)
511   format(i6,10000i4)
512   format(i6,2(2x,e13.6))
520   format(10000(2x,e9.3))     
530   format(i5,1x,10000(2x,e9.3))     
540   format(' is=',i12,'  irede=',i12,'  nm=',i12, 
     .'  tfinal= ',e14.7)

1000      stop
      end
            

c======================================================
c======================================================
      subroutine orderset(set,n,m,icol)
c     it orders, descending, a set of n numbers, conserving the respective
c     positions of other sets
c      m indicates the number of columns in the set
c     icol indicates the column which will be considered for the ordering  
      parameter(npm=3283)

      integer set(npm,m),x1 
      itera = 0
10    icont = 0

      itera = itera + 1

      do  20  j= 1,n-1

c      write(*,*)j,set(j,icol),set(j+1,icol)
c      to order in ascending order use the following command
      if (set(j,icol).gt.set(j+1,icol)) then
c      to order in descending order use the following command
c      if (set(j,icol).lt.set(j+1,icol)) then

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


c======================================================
c======================================================
c
      function rannyu()
      implicit double precision (a-h,o-z)
c        real*8 rannyu, twom12
      parameter (twom12 = 1/4096.d0)
      common /rnyucm/ mk1,mk2,mk3,mk4,km1,km2,km3,km4
c
c     this is rannyu as modified by a. sokal 9/26/85.
c     it is linear congruencial with modulus m = 2**48,incremen_tempoc=1,
c     and multiplier a = (2**36)*mk1 + (2**24)*mk2 + (2**12)*mk3 + mk4.
c     the multiplier is stored in common (see subroutine setrn)
c     and is set to a = 31167285 (recommended by knuth, vol. 2,
c     2nd ed., p. 102).
c
      i1 = km1*mk4 + km2*mk3 + km3*mk2 + km4*mk1
      i2 = km2*mk4 + km3*mk3 + km4*mk2
      i3 = km3*mk4 + km4*mk3
      i4 = km4*mk4  +  1
      km4 = mod(i4, 4096)
      i3 = i3 + i4/4096
      km3 = mod(i3, 4096)
      i2 = i2 + i3/4096
      km2 = mod(i2, 4096)
      km1 = mod(i1 + i2/4096, 4096)
      rannyu = twom12*(dble(km1)+twom12*(dble(km2)+
     .         twom12*(dble(km3)+twom12*(dble(km4)))))
      return
      end

c======================================================
c======================================================
