function [ sorg_filtrata ] = filtro_mediana( sorgente,patternR,patternG,patternB  )

% Applica il filtro mediana a sorgente restituendo l'immagine filtrata
sorgente_big=zeros(size(sorgente,1)+4,size(sorgente,2)+4,size(sorgente,3));

sorgente_big(3:end-2,3:end-2,:)=sorgente;
sorgente_big(1:2,1:2,:)=sorgente(1:2,1:2,:);%quadrato 2x2 replicato nell'angolo in alto a sinistra
sorgente_big(1:2,end-1:end,:)=sorgente(1:2,end-1:end,:);%quadrato 2x2 replicato nell'angolo in alto a destra
sorgente_big(end-1:end,1:2,:)=sorgente(end-1:end,1:2,:);%quadrato 2x2 replicato nell'angolo in basso a sinistra
sorgente_big(end-1:end,end-1:end,:)=sorgente(end-1:end,end-1:end,:);%quadrato 2x2 replicato nell'angolo in basso a destra

sorgente_big(3:end-2,1:2,:)=sorgente(:,1:2,:);%replica prime due colonne a sinistra
sorgente_big(1:2,3:end-2,:)=sorgente(1:2,:,:);%replica prime due righe in alto
sorgente_big(end-1:end,3:end-2,:)=sorgente(end-1:end,:,:);%replica ultime due righe in basso
sorgente_big(3:end-2,end-1:end,:)=sorgente(:,end-1:end,:);%replica ultime due colonne a destra
orig_red=double(sorgente_big(:,:,1));%creo i 3 canali red green blue
orig_green=double(sorgente_big(:,:,2));
orig_blue=double(sorgente_big(:,:,3));



[imm_puriR,imm_interR,maschera_puriR]=extraction(orig_red,patternR);
[imm_puriG,imm_interG,maschera_puriG]=extraction(orig_green,patternG);
[imm_puriB,imm_interB,maschera_puriB]=extraction(orig_blue,patternB);



 hrb=0.25*[1 2 1;2 4 2;1 2 1];
 hg=0.25*[0 1 0;1 4 1;0 1 0];
 
 
 mat_bilineare_red=imfilter(imm_puriR,hrb);
 mat_bilineare_blue=imfilter(imm_puriB,hrb);
 mat_bilineare_green=imfilter(imm_puriG,hg);
 
 
 redgreen=mat_bilineare_red-mat_bilineare_green;
 redblue=mat_bilineare_red-mat_bilineare_blue;
 greenblue=mat_bilineare_green-mat_bilineare_blue;
 
[sizer, sizec]=size(orig_red);
 
 Mrg = medfilt2(redgreen);
 Mrb = medfilt2(redblue);
 Mgb = medfilt2(greenblue);
 
 for i=3:sizer-2
     for j=3:sizec-2
         if(maschera_puriG(i,j)==0 && maschera_puriR(i,j)==1)
             imm_puriG(i,j)=imm_puriR(i,j)-Mrg(i,j);
         end
         if(maschera_puriG(i,j)==0 && maschera_puriB(i,j)==1)
             imm_puriG(i,j)=imm_puriB(i,j)+Mgb(i,j);
         end
         if(maschera_puriR(i,j)==0 && maschera_puriG(i,j)==1)
             imm_puriR(i,j)=imm_puriG(i,j)+Mrg(i,j);
         end
         if(maschera_puriR(i,j)==0 && maschera_puriB(i,j)==1)
             imm_puriR(i,j)=imm_puriB(i,j)+Mrb(i,j);
         end
         if(maschera_puriB(i,j)==0 && maschera_puriG(i,j)==1)
             imm_puriB(i,j)=imm_puriG(i,j)-Mgb(i,j);
         end
         if(maschera_puriB(i,j)==0 && maschera_puriR(i,j)==1)
             imm_puriB(i,j)=imm_puriR(i,j)-Mrb(i,j);
         end
     end
 end
sorg_filtrata(:,:,1)=imm_puriR(3:end-2,3:end-2);
sorg_filtrata(:,:,2)=imm_puriG(3:end-2,3:end-2);
sorg_filtrata(:,:,3)=imm_puriB(3:end-2,3:end-2);

%sorg_filtrata = uint8(sorg_filtrata);