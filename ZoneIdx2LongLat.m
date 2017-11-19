function [ Long, Lat ] = ZoneIdx2LongLat( ZoneIdx )
%ZONEIDX2LONGLAT 此处显示有关此函数的摘要
%   此处显示详细说明
% 将100*100区域中每个区域的中心部分选为该部分所有单车的坐标
% 该区域南北确界为  31.0202935288~ 31.0454378038 东西为  121.4206362038~  121.4680599309 
% （经纬度来源 http://www.gpsspg.com/maps.htm 的百度地图经纬度）
% 同时区域的编号是从左上序数往右下递增 ↓↓↓这种形式

LatSeg=linspace(31.0202935288,31.0454378038,101);
LongSeg=linspace(121.4206362038,121.4680599309,101);
LongIdx=ceil(ZoneIdx/100);
LatIdx=101-mod(ZoneIdx,100);
Long=LongSeg(LongIdx);
Lat=LatSeg(LatIdx);
end

