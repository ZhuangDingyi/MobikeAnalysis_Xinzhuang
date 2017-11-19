
function Json2excel( totalobjects,Directory,Output_name,time)
% totalobeject应该为一个n*1的结构体，里面包含多个objects
%Directory为输出文件夹
%Outputname应该遵循着一定的命名规则
Output_table=[];

for counter_ttob=1:size(totalobjects,1)
    if  isfield(totalobjects(counter_ttob),'object')
        temp_struct=totalobjects(counter_ttob).object;
    else if isfield(totalobjects(counter_ttob),'bike')
        temp_struct=totalobjects(counter_ttob).bike;
        end
    end
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
[~,idx_total,~]=unique(Output_table.bikeIds);
    bikeIds=Output_table.bikeIds(idx_total);
    Long=Output_table.Long(idx_total);
    Lat=Output_table.Lat(idx_total);
    biketype=Output_table.biketype(idx_total);
    Time=cell(length(bikeIds),1);
    Time(:,1)={[num2str(time) ':00:00']};
    Output_table=table(bikeIds,Long,Lat,biketype,Time);
writetable(Output_table,[Directory '\' Output_name '.csv'])

end
