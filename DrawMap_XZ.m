function [Frame,a]=DrawMap_XZ( Mat,MapName,width,height)
%Mat 需要为 100*100的区域阵
XZ_map=imread('F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\ArcGis_Vis_Test\LongLat_XZ_PS\成品.png');
a=figure;
[x_map,y_map,~]=size(XZ_map);
imshow(XZ_map)
hold on
s=surf(linspace(1,y_map,height),linspace(1,x_map,width),0*Mat,Mat);
shading interp
view(2)
hold off
alpha(s,.5)
title(MapName)

drawnow
ax = gca;
ax.Units = 'pixels';
pos = ax.Position;
ti = ax.TightInset;

rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
Frame= getframe(ax,rect);

end

