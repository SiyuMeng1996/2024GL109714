

function [outputArg1] = Read_data_climato_medu(Curr,Para_name,Para_in_Data,Para_in_Data1,start_date,end_date)


%%%%%%%%%  Curr-路径
%%%%%%%%%  Para_name--你给变量起的名字
%%%%%%%%%  Para_in_Data--数据中变量的名字
%%%%%%%%%  dimention--网格纬度（数据文件名称）

%% 准备读取数据
Para_name    = Para_name;
start_date   = start_date;
end_date     = end_date;

File = dir(fullfile(Curr,['medu*','.nc']));  
FileNames = {File.name}';   
Data_mid=[];


%% 判断一下这个数据有多少维度

Data_mid1 = ncread([Curr,FileNames{1,1}],Para_in_Data);
depth1    = size(Data_mid1,3);%数据有多少层
Dimm      = ndims(Data_mid1);

%% 读取数据里的经纬度，并设定我想插值的经纬度

Lon = -180+1 /2 : 1 : 180-1/2;
Lat = -90+1/2 : 1 :  90-1/2;
[Lon,Lat] = meshgrid(Lon,Lat); 

xii= double(squeeze(ncread([Curr,FileNames{1,1}],'nav_lat'))');
yii= double(squeeze(ncread([Curr,FileNames{1,1}],'nav_lon'))');

try %这里试试读一下深度
depth_UKESM= squeeze(ncread([Curr,FileNames{1,1}],'depth*'))';
end

switch Dimm
%% 开始读数据-2d的版本
case 2 
Data_mid = nan*ones(end_date-start_date+1,332,362);
for lll=start_date:end_date
Data_mid1=ncread([Curr,FileNames{lll,1}],Para_in_Data);
Data_mid2=ncread([Curr,FileNames{lll,1}],Para_in_Data1);
Data_mid1=Data_mid1+Data_mid2;

Data_mid1=permute(Data_mid1,[2,1]);
Data_mid1 = reshape(Data_mid1,[1,size(Data_mid1)]);
Data_mid(lll-start_date+1,:,:)=Data_mid1;
end

Data_mid = squeeze(nanmean(Data_mid));%平均数据
DATA_cc  = griddata(double(xii),double(yii),Data_mid,Lat,Lon);%插值

%% 3d的版本
case 3
Data_mid = nan*ones(end_date-start_date+1,depth1,332,362);
for lll=start_date:end_date
Data_mid1=squeeze(ncread([Curr,FileNames{lll,1}],Para_in_Data,[1 1 1 1],[inf inf inf inf]));
Data_mid2=squeeze(ncread([Curr,FileNames{lll,1}],Para_in_Data1,[1 1 1 1],[inf inf inf inf]));
Data_mid1=Data_mid1+Data_mid2;

Data_mid1=permute(Data_mid1,[3,2,1]);
Data_mid1 = reshape(Data_mid1,[1,size(Data_mid1)]);
Data_mid(lll-start_date+1,:,:,:)=Data_mid1;
end

% 取消中间空白的一部分
Data_mid(:,:,:,1)=[];
Data_mid(:,:,:,end)=[];
xii(:,1)=[];
xii(:,end)=[];
yii(:,1)=[];
yii(:,end)=[];

%%
Data_mid=squeeze(nanmean(Data_mid));%平均数据
DATA_cc=nan*ones(size(Data_mid,1),180,360);
for xx=1:size(Data_mid,1)
    DDAA = squeeze(Data_mid(xx,:,:));
    DATA_cc(xx,:,:)=griddata(double(xii),double(yii),DDAA,Lat,Lon);
end
end

outputArg1 = DATA_cc;

%% %%%%%%%%%%%%%% plot %%%%%%%%%%%%%%%%
figure
ax1=subplot(1,1,1);
set(gcf,'outerposition',get(0,'screensize'))
m_proj('miller','long',[-180 180],'lat',[-70 70])

if ndims(DATA_cc)==3
m_pcolor(Lon,Lat,squeeze(DATA_cc(1,:,:)))
elseif ismatrix(DATA_cc)
m_pcolor(Lon,Lat,squeeze(DATA_cc(:,:)))
end
shading flat
colormap(jet(20))
colorbar
hold on
m_coast('patch',[.6 .6 .6])
m_grid('box','fancy','tickdir','in','linewidth',3,'fontsize',16,'Ytick',[-90:30:90],'Xtick',[-180:60:180])

end