
%% select upwelling regions

Data_CU956 = Read_data_climato_medu('C:\1Test_Chl_control\0_Data\NEW\u-cu956\','Chl','CHD','CHN',241,359);
Data_CU957 = Read_data_climato_medu('C:\1Test_Chl_control\0_Data\NEW\u-cu957\','Chl','CHD','CHN',241,359);


%% 
for SITU = 1:3
    
switch SITU
    case 1    
        LLLL2 = squeeze(Data_CU956);
    case 2
        LLLL2 = squeeze(Data_CU957);
    case 3
        LLLL2 = squeeze(Data_CU956-Data_CU957);
end

DATA_RED  = nan*ones(1,75,20);%set up a blank matrix, assume having 30 rows
DATA_BLUE = nan*ones(1,75,20);
tot1 = 0;
tot2 = 0;


for yy=1:180
    
MARK_column = squeeze(MARK_RED_BLUE(yy,:));

if any(MARK_column>0.1)
    LLLL_column  = squeeze(LLLL2(:,yy,:));
    DATA_mid     = squeeze(LLLL_column(:,find(MARK_column==1)));
    tot1         = tot1+1;
    DATA_RED(tot1,:,:)  =DATA_mid;
elseif any(MARK_column<-0.1)
    LLLL_column  = squeeze(LLLL2(:,yy,:));
    DATA_mid     = squeeze(LLLL_column(:,find(MARK_column==-1)));
    tot2         = tot2+1;
    DATA_BLUE(tot2,:,:)  =DATA_mid;
end
end


switch SITU
    case 1    
         data_p = squeeze(nanmean(DATA_RED));
         Plot_crosssection_along_coast(data_p,[0 0.6],1,20,RdYlBu10,{'2000','1700','1400','1100','800','500','200'});
         saveas(gcf,['PLOT_U_RED_956'], 'jpg')
         data_p = squeeze(nanmean(DATA_BLUE));
         Plot_crosssection_along_coast(data_p,[0 0.6],1,20,RdYlBu10,{'2000','1700','1400','1100','800','500','200'});
         saveas(gcf,['PLOT_U_BLUE_956'], 'jpg')
    case 2
         data_p = squeeze(nanmean(DATA_RED));
         Plot_crosssection_along_coast(data_p,[0 0.6],1,20,RdYlBu10,{'2000','1700','1400','1100','800','500','200'});
         saveas(gcf,['PLOT_U_RED_957'], 'jpg')
         data_p = squeeze(nanmean(DATA_BLUE));
         Plot_crosssection_along_coast(data_p,[0 0.6],1,20,RdYlBu10,{'2000','1700','1400','1100','800','500','200'});
         saveas(gcf,['PLOT_U_BLUE_957'], 'jpg')
    case 3
         data_p = squeeze(nanmean(DATA_RED));
         Plot_crosssection_along_coast(data_p,[-0.05 0.05],1,20,RdYlBu10,{'2000','1700','1400','1100','800','500','200'});
         saveas(gcf,['PLOT_U_RED_diff'], 'jpg')
         data_p = squeeze(nanmean(DATA_BLUE));
         Plot_crosssection_along_coast(data_p,[-0.05 0.05],1,20,RdYlBu10,{'2000','1700','1400','1100','800','500','200'});
         saveas(gcf,['PLOT_U_BLUE_diff'], 'jpg')
end
end