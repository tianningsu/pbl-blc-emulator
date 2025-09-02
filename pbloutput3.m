function output=pbloutput3(mon_cal,rh_sfcnew,u_sfcnew,v_sfcnew,p_sfcnew,T_sfcnew,SHnew,LHnew,erar,erau,erav,erat,eraz)

output=nan(13,206);


h=eraz;
t=erat;

a1=[50:50:1000];
a2=[1100:100:2000];
a3=[2250:250:4000];
a4=[4500:500:8000];
aa=[a1,a2,a3,a4];

[sorted_h, indices] = sort(h); % Use indices to rearrange 
sorted_t = t(indices);
h=sorted_h(sorted_t>0&sorted_h>=0);
t=sorted_t(sorted_t>0&sorted_h>=0);

if length(h)>=5&&length(t)>=5&&length(erar(erar>0&eraz>=0))>=5&&length(erau(abs(erau)<100&eraz>=0))>=5&&length(erav(abs(erav)<100&eraz>=0))>=5

he=eraz(erat>0&eraz>=0);
te=erat(erat>0&eraz>=0);
begt=interp1([min([he-1,0]) he],[te(1) te],aa);

he=eraz(erar>0&eraz>=0);
te=erar(erar>0&eraz>=0);
begr=interp1([min([he-1,0]) he],[te(1) te],aa);

he=eraz(abs(erau)<100&eraz>=0);
te=erau(abs(erau)<100&eraz>=0);
begu=interp1([min([he-1,0]) he],[te(1) te],aa);

he=eraz(abs(erav)<100&eraz>=0);
te=erav(abs(erav)<100&eraz>=0);
begv=interp1([min([he-1,0]) he],[te(1) te],aa);


enre=nan(1,length(t));    
enre(1)=0;       
tbase=t(1);
hbase=h(1);
for j=2:length(t)  
if t(j)>tbase
enre(j)=enre(j-1)+(t(j)-tbase)*((h(j)+hbase)/2);
tbase=t(j);
hbase=h(j);
else
enre(j)=enre(j-1);    
end
end

enall=zeros(1,24)*nan;
for j=11:24   
a=SHnew(13:j)/(1004*1.225);
enall(j)=nansum(a)*3600;
end

pblsh=nan(1,24);
e=enre;
if mean(e)>0
for j=11:24
a=enall(j)*1.3;
    if a<max(e)&&a>0
d = find_height(e, h, a);
pblsh(j)=d;    
    end
    if a<=0
pblsh(j)=10;    
    end    
end
end

theta_sfcnew=calpt(T_sfcnew,p_sfcnew);


thr=1.5;
pblpa1=nan(1,24)*nan;
for k=11:24
tt=theta_sfcnew(k)+thr;
if tt>200&&max(t)>tt&&tt>t(1)
d = find_height(t, h, tt);
pblpa1(k)=d;
end
if tt<t(1)&&tt>200
pblpa1(k)=10;
end
end

varlcl=nan(1,24);
for j=11:24
varlcl(j)=lclcal(p_sfcnew(j)*100,T_sfcnew(j),rh_sfcnew(j)/100,false,false);
end

for j=12:24
output(j-11,:)=[mon_cal,(j-1),p_sfcnew(j-1:j),rh_sfcnew(j-1:j),u_sfcnew(j-1:j),v_sfcnew(j-1:j)...
    ,theta_sfcnew(j-1:j),varlcl(j-1:j),pblsh(j-1:j),pblpa1(j-1:j),SHnew(j-1:j)...
    ,LHnew(j-1:j),begr,begu,begv,begt];%,sea_ordert];%,hour_ordert,mon_ordert];%,BT11t'];
end


end
end

