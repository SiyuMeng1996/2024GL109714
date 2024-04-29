function [index_NAO_final]=Plot_crosssection_along_coast(data_p,cas,lon_min,lon_max,colormapp,AAA);

figure
set(gcf,'unit','pixels','position',[0,0,550,600])
ax1 = axes("Position",[0.15 0.15 0.7 0.7]);

%绘图+渲染
pcolor(data_p(1:39,:))
shading flat
%设置colorbar
caxis(cas)
colormap(flipud(colormapp))
colorbar
hcb=colorbar;
set(hcb,'fontsize',18);
%设置XY轴
hold on
%AAA = convert_from_mat_2_longitudestr([lon_min:3:lon_max]);%这里是可以根据输入longitude来生成xlabel
set(gca,'xlim',[0 size(data_p,2)+1],'xtick',[1:3:size(data_p)],'xticklabel',AAA,'fontsize',17)
set(gca,'ylim',[0 41],'ytick',[0:4:40],'yticklabel',{'0','4','10','20','35','60','98','148','220','334','500'},'fontsize',17)
set(hcb,'Ytick',[cas(1):(cas(end)-cas(1))/10:cas(end)])


set(gca,'Ydir','reverse')
xtickangle(30)
ytickangle(30)
%设置网格
box on
grid on
set(gca,'GridLineStyle',':','LineWidth',2,'GridColor','k')
set(gca,'fontsize',18)

end