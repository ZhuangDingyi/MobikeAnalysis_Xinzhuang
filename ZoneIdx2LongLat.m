function [ Long, Lat ] = ZoneIdx2LongLat( ZoneIdx )
%ZONEIDX2LONGLAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ��100*100������ÿ����������Ĳ���ѡΪ�ò������е���������
% �������ϱ�ȷ��Ϊ  31.0202935288~ 31.0454378038 ����Ϊ  121.4206362038~  121.4680599309 
% ����γ����Դ http://www.gpsspg.com/maps.htm �İٶȵ�ͼ��γ�ȣ�
% ͬʱ����ı���Ǵ��������������µ��� ������������ʽ

LatSeg=linspace(31.0202935288,31.0454378038,101);
LongSeg=linspace(121.4206362038,121.4680599309,101);
LongIdx=ceil(ZoneIdx/100);
LatIdx=101-mod(ZoneIdx,100);
Long=LongSeg(LongIdx);
Lat=LatSeg(LatIdx);
end

