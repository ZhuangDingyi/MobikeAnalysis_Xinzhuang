
function Output_table=Json2excel_fullcsv( totalobjects,time)
% totalobejectӦ��Ϊһ��n*1�Ľṹ�壬����������objects
%DirectoryΪ����ļ���
%OutputnameӦ����ѭ��һ������������
Output_table=[];

for counter_ttob=1:size(totalobjects,1)
    if  isfield(totalobjects(counter_ttob),'object')
        temp_struct=totalobjects(counter_ttob).object;
    else if isfield(totalobjects(counter_ttob),'bike')
        temp_struct=totalobjects(counter_ttob).bike;
        end
    end
    if size(temp_struct,1)<=1
        continue;
    else 
    temp_table=struct2table(temp_struct);
    [~,idx,~]=unique(temp_table.bikeIds);
    bikeIds=temp_table.bikeIds(idx);
    Long=temp_table.distX(idx);
    Lat=temp_table.distY(idx);
%     Long=temp_table.Long(idx);
%     Lat=temp_table.Lat(idx);
    biketype=temp_table.biketype(idx);
    Time=cell(length(bikeIds),1);
    Time(:,1)={[num2str(time) ':00:00']};
    Output_table=[Output_table;table(bikeIds,Long,Lat,biketype,Time)];
    end
end
[~,idx_total,~]=unique(Output_table.bikeIds);
    bikeIds=Output_table.bikeIds(idx_total);
    Long=Output_table.Long(idx_total);
    Lat=Output_table.Lat(idx_total);
    biketype=Output_table.biketype(idx_total);
    Time=cell(length(bikeIds),1);
    Time(:,1)={[num2str(time) ':00:00']};
%     [Long_wgs84,Lat_wgs84]=Baidu_WGS84_transfer(Long,Lat);%ת��Ϊwgs����
       Output_table=table(bikeIds,Long,Lat,biketype,Time);
%        Output_table=table(bikeIds,Long_wgs84,Lat_wgs84,biketype,Time);
% writetable(Output_table,[Directory '\' Output_name '.csv'])
    
end

