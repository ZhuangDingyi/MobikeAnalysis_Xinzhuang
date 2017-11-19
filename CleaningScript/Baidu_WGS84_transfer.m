function [ wgs_long, wgs_lat ] = Baidu_WGS84_transfer(bd_long,bd_lat)
%BAIDU_WGS84_TRANSFER 此处显示有关此函数的摘要
%   将百度坐标转化为WGS坐标
%   先将百度坐标转化为gcj02坐标
%   再将gcj02坐标转化为wgs84
%   与原Python文件输出结果一样并且在bdp上 百度地图和wgs 的坐标地图上相差不大

    [lng,lat]=Baidu_GCJ_transfer(bd_long,bd_lat);
    [wgs_long,wgs_lat]=GCJ_WGS84_transfer(lng,lat);
end

function [gcj_long, gcj_lat]=Baidu_GCJ_transfer( bd_long,bd_lat )
%  百度坐标系(BD-09)转火星坐标系(GCJ-02)
%     百度——>谷歌、高德
%     :param bd_lat:百度坐标纬度
%     :param bd_lon:百度坐标经度
%     :return:转换后的坐标列表形式
    x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    x = bd_long - 0.0065;
    y = bd_lat - 0.006;
    z = sqrt(x.*x + y.*y) - 0.00002*sin(y.*x_pi);
    theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    gcj_long = z.*cos(theta);
    gcj_lat = z.*sin(theta);
    
end

function [wgs_long,wgs_lat]=GCJ_WGS84_transfer(lng,lat)
    dlat = transformlat(lng - 105.0, lat - 35.0);
    dlng = transformlng(lng - 105.0, lat - 35.0);
    radlat = lat / 180.0 * pi;
    magic = sin(radlat);
    ee = 0.00669342162296594323; %扁率
    a = 6378245.0;  % 长半轴
    magic = 1 - ee * magic .* magic;
    sqrtmagic = sqrt(magic);
    dlat = (dlat * 180.0) ./ ((a * (1 - ee)) ./ (magic .* sqrtmagic) * pi);
    dlng = (dlng * 180.0) ./ (a ./ sqrtmagic .* cos(radlat) * pi);
    mglat = lat + dlat;
    mglng = lng + dlng;
    wgs_long=lng * 2 - mglng;
    wgs_lat=lat * 2 - mglat;
end

function ret=transformlat(lng,lat)
    ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat .* lat + ...
          0.1 * lng .* lat + 0.2 * sqrt(abs(lng));
    ret =ret+ (20.0 * sin(6.0 * lng * pi) + 20.0 *...
            sin(2.0 * lng .* pi)) * 2.0 / 3.0;
    ret =ret+ (20.0 * sin(lat * pi) + 40.0 *...
            sin(lat / 3.0 * pi)) * 2.0 / 3.0;
    ret =ret+ (160.0 * sin(lat / 12.0 * pi) + 320 *...
            sin(lat * pi / 30.0)) * 2.0 / 3.0;
end


function ret=transformlng(lng, lat)
    ret = 300.0 + lng + 2.0 * lat + 0.1 * lng .* lng + ...
          0.1 * lng .* lat + 0.1 * sqrt(abs(lng));
    ret = ret+ (20.0 * sin(6.0 * lng * pi) + 20.0 *...
            sin(2.0 * lng * pi)) * 2.0 / 3.0;
    ret = ret+(20.0 * sin(lng * pi) + 40.0 *...
            sin(lng / 3.0 * pi)) * 2.0 / 3.0;
    ret = ret+(150.0 * sin(lng / 12.0 * pi) + 300.0 *...
            sin(lng / 30.0 * pi)) * 2.0 / 3.0;
    
end