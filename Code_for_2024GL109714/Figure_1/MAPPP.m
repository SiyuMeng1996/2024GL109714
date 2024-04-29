%% select upwelling regions

Data_CU956_t = Read_data_climato_nemo('C:\1Test_Chl_control\0_Data\NEW\u-cu956\','T','thetao_con','T',241,359);
Data_CU957_t = Read_data_climato_nemo('C:\1Test_Chl_control\0_Data\NEW\u-cu957\','T','thetao_con','T',241,359);
c_diff_high = squeeze(Data_CU956_t(1,:,:));
c_diff_low  = squeeze(Data_CU957_t(1,:,:));
LLLL1 = squeeze(c_diff_high - c_diff_low);


%% mark the region with positive/negative value

MARK_RED_BLUE  = zeros(180,360);

for pla = 1:6
switch pla
case 1
%%%%%%%%%%%%%%%%%%%%%%区域1-加利福尼亚
 yy1=125;
 yy2=132;
 xx1=49;
 xx2=73;     
case 2
 %%%%%%%%%%%%%%%%%%%%%%区域2-秘鲁
 yy1=73;
 yy2=80;
 xx1=93;
 xx2=115;     
case 3
 %%%%%%%%%%%%%%%%%%%%%区域3-Chile
 yy1=50;
 yy2=68;
 xx1=104;
 xx2=118;     
case 4
 %%%%%%%%%%%%%%%%%%%%%%区域4-NW
 yy1=98;
 yy2=115;
 xx1=160;
 xx2=172;     
case 5
 %%%%%%%%%%%%%%%%%%%%%%区域5-Benguela
 yy1=65;
 yy2=84;
 xx1=189;
 xx2=196;     
case 6
  %%%%%%%%%%%%%%%%%%%%%%区域6-Namibia
 yy1=72;
 yy2=75;
 xx1=189;
 xx2=196; 
end


baseon = LLLL1(yy1:yy2,xx1:xx2);

for yy=1:(yy2-yy1+1)
    LOO = squeeze(baseon(yy,:));%把这里的一行数据拿出来
    LOO = LOO(find(~isnan(LOO)));%把里面的nan都去掉
    
    xx_nonan   = find(LOO==LOO(end))-1;%看看最后一个有数据的点在哪里啊？
    
     if LOO(end)>0
     MARK_RED_BLUE(yy1+yy-1,xx1+xx_nonan-20+1:xx1+xx_nonan) = 1;
     elseif LOO(end)<0
     MARK_RED_BLUE(yy1+yy-1,xx1+xx_nonan-20+1:xx1+xx_nonan) = -1;   
     end
     
     if pla==2
     MARK_RED_BLUE(yy1+yy-1,xx1+xx_nonan-20+1:xx1+xx_nonan) = -1;
     end
end
end


%% plot map
close all
CAXX2  = [-1 -0.5 -0.3 -0.1 -0.05 0 0.05 0.1 0.3 0.5 1]*0.3;
DATA_p = LLLL1;
Plot_2D_descreet_two_side(DATA_p,CAXX2,RdYlBu10,'flipud',180,390,-60,60,1,'Miller') 


Lon = -180+1 /2 : 1 : 180-1/2;
Lat = -90+1/2 : 1 :  90-1/2;
[Lon,Lat] = meshgrid(Lon,Lat); 

m_contour(Lon+210,Lat,circshift(MARK_RED_BLUE,[0,-210]),[-0.5 -0.5],'color',[132 112 255]/255,'linewidth',1.7)
m_contour(Lon+210,Lat,circshift(MARK_RED_BLUE,[0,-210]),[ 0.5  0.5],'r','linewidth',1.7)
