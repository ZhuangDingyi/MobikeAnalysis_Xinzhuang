 Directory='F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\allData';
% Mobike_ds=datastore([Directory '\20170526_time_all.csv']);
% Mobike_ds.formats={'%s %d8 %d16 %u8 %f %f %d16 %{mm:ss}D'};
% file_tile={'bikeID','biketype','distID','distNUM','Longitude','Latitude','distance','Time'};
% ds_time_all=textscan(fileID,'%s %d8 %d16 %u8 %f %f %d16 %{HH:mm:ss}D','delimiter',',');
% fclose(fileID);
% 因为从Louvain脚本中引入 datastore_all 故先注释 Mobike_ds=readtable('F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\allData\20170526_time_all_refine.csv');
Mobike_ds=dataStore_all;
datetime='20170706-20170813';
%% Make Use Rate
BikeId=Mobike_ds.bikeIds;%此处的BikeIds 有时可以识别有时不行,多刷新几下
[BikeId_unique,Old_New,New_Old]=unique(BikeId);%make bikeids unique
Bike_id_LongLat=table(Mobike_ds.bikeIds,Mobike_ds.Long,Mobike_ds.Lat);

%% Use Rate
UseRate_OutPut=zeros(length(BikeId_unique),1);
for counter=1:length(BikeId_unique)  
    [~,idx,~]=unique(Mobike_ds.Long(New_Old==counter));
    UseRate_OutPut(counter)= length(idx)-1;%每辆单车使用次数
    %BikeId_unique{counter}(end)='';
end
%% Create UseNum.CSV
BikeId_unique=string(BikeId_unique);
UseRate_OutPut_table=table(BikeId_unique,UseRate_OutPut);%Remove Zero Row
writetable(UseRate_OutPut_table,[Directory '\' datetime 'UseRate.csv'])

%% Function Area
Time=Mobike_ds.Time;
Long=Mobike_ds.Long;
Lat=Mobike_ds.Lat;
FuncAreaNum=zeros(length(BikeId),1);
tic
parfor counter_Function=1:length(BikeId)
    FuncAreaNum(counter_Function)=GetFunctionArea_inpolygon([Long(counter_Function) Lat(counter_Function)]);
end
toc
tabulate(FuncAreaNum)
dlmwrite('zero.csv',[Long(FuncAreaNum==0) Lat(FuncAreaNum==0)],'Precision','%.10f')
FunctionAreaOutput_table=table(BikeId,Long,Lat,Time,FuncAreaNum);
writetable(FunctionAreaOutput_table,[Directory  '\' datetime 'FuncAreaNum.csv'])