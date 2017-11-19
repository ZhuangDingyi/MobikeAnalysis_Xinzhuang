clc
% ��Ҫ����ȫ�ֵı���
width=100;
height=100;
GridsNum=width*height;


%% --------------Ingestion----------------------
VariableNames={'bikeIds','Long','Lat','biketype','Time'};
TextscanFormats={'%s','%.15f', '%.15f' ,'%u' ,'%s'};
dtNum='Test4All'; %����ά������
Directory=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\Data'];
Output_image='F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\Output_image_minhang';
Dir_Stru=dir(Directory);
%������Ҫ��ȡÿһ���ļ��Ժ��ٽ��кϲ�OD_MAN���������������ʼ��
OD_M_all=sparse(zeros(10000,10000)); %�����ΪO �����ΪD �Խ���û����
OD_A_all=sparse(zeros(10000,10000)); %�����ΪO �����ΪD �Խ���û����
OD_N_all=sparse(zeros(10000,10000)); %�����ΪO �����ΪD �Խ���û����
%----������1017-10-06
Supply_M_all=sparse(zeros(10000,1));
Supply_A_all=sparse(zeros(10000,1));
Supply_N_all=sparse(zeros(10000,1));
%--------

dataStore_all=table();
Bar_Handler=waitbar(0,'Folder Processing');


for counter_Folder=3:size(Dir_Stru,1)

ds=datastore([Directory '\' Dir_Stru(counter_Folder).name],...
    'VariableNames',VariableNames,'TextscanFormats',TextscanFormats,'IncludeSubfolders',false,'FileExtensions','.csv'...
    ,'Type','tabulartext');
dataStore=readall(ds);
%% ---------------Processing---------------
t_long=dataStore.Long; %t_long��t_lat��ֻ�ǲ�����;
t_lat=dataStore.Lat;
t_bikeid=dataStore.bikeIds;
% �ȼ�໮���������꣬�õ�һ��100*100�Ĵ����
zone_long=linspace(121.4206362038,121.4680599309,101);%��101������100��
zone_lat=linspace(31.0202935288,31.0454378038,101);
t_long_idx=zeros(length(t_long),1);
t_lat_idx=zeros(length(t_lat),1);
t_zone_idx=zeros(length(t_lat),1);
for counter=1:length(t_long_idx)
    tmp_lng=find(zone_long>=t_long(counter));%ֻ�е�һ����������Ҫ��,������Ƚ��٣������������
    tmp_lat=find(zone_lat>=t_lat(counter));
    if ~isempty(tmp_lng)&&~isempty(tmp_lat)
    t_long_idx(counter)=tmp_lng(1)-1;%��ӳ����������������������Ļ��ֵ�
    t_lat_idx(counter)=tmp_lat(1)-1;
    end
end
clear tmp_lat tmp_lng counter
tmp_zone_idx=find(t_long_idx>0&t_lat_idx>0);
t_zone_idx(tmp_zone_idx)=(t_long_idx(tmp_zone_idx)-1)*100+101-t_lat_idx(tmp_zone_idx);%0��ʾ���ڻ��ֵ������д��������������µ��� ������������ʽ������������һ��
clear tmp_zone_idx
dataStore.ZoneIdx=t_zone_idx;%������������ӵ�����
% Write Table or not
%% ��ʼ����OD����
%�ȶ�ʱ��˳����д���
t_time=dataStore.Time;
for counter_time=1:length(t_time)
    tmp_time=t_time{counter_time};
    tmp_reg=regexp(tmp_time,':','split');
    t_time{counter_time}=str2double(tmp_reg{1});
end
clear tmp_time tmp_reg counter_time
t_time=cell2mat(t_time);
[t_time,idx_time]=sort(t_time);%idx_time�ǰ���ʱ�������Ժ��,��֤�����M A N�õ���idx_timeҲ��˳���
%% �������õı��������ﰴʱ������
t_long=t_long(idx_time);
t_lat=t_lat(idx_time);
t_bikeid=t_bikeid(idx_time);
t_zone_idx=t_zone_idx(idx_time);
%����Լ���������о��ķ�Χ��
t_long=t_long(t_zone_idx>0);
t_lat=t_lat(t_zone_idx>0);
t_bikeid=t_bikeid(t_zone_idx>0);
t_time=t_time(t_zone_idx>0);
t_zone_idx=t_zone_idx(t_zone_idx>0);
%biketype=biketype(idx_time)
% clear idx_time
%������������з�ʱ���
%���������� ����+���磨6:00-13:00��M  ���絽����14:00-18:00��A  ���ϣ�19:00-00:00��N
idx_time_M=find(t_time>0&t_time<=13);   
idx_time_A=find(t_time>13&t_time<=18);
idx_time_N=find(t_time>18&t_time<=23|t_time==0);
%��ʼ���ɸ��Ե�O-D����
%%��ȡ������ʱ��εľ�γ���Լ�ID
t_long_M=t_long(idx_time_M);
t_lat_M=t_lat(idx_time_M);
t_bikeid_M=t_bikeid(idx_time_M);
t_zone_idx_M=t_zone_idx(idx_time_M);

t_long_A=t_long(idx_time_A);
t_lat_A=t_lat(idx_time_A);
t_bikeid_A=t_bikeid(idx_time_A);
t_zone_idx_A=t_zone_idx(idx_time_A);

t_long_N=t_long(idx_time_N);
t_lat_N=t_lat(idx_time_N);
t_bikeid_N=t_bikeid(idx_time_N);
t_zone_idx_N=t_zone_idx(idx_time_N);





%��ÿ��ʱ����е�bikeidsȥ�أ����ص���γ���п����Ƿ���λ���ϵĸı䣬��������¼���ǵ�OD 
%�����Ƿ���ҪMATLABͼ�۵�֪ʶ��
%�Ϳ���ѧ�������꣬�������һ�����������
%���ǽ�MAN����ʱ�������bikeidsΪ����㣬�ж���Ӧ�ľ�γ�ȸı��Ƿ�ı䣬��������ʱ��˳�򹹽�OD����OD����Ϊ�зֵ�100*100��square����asymmetric������
%% �ȶ�morning���д������´���ֻ�����һ�������ʱ���
OD_M=zeros(10000,10000); %�����ΪO �����ΪD �Խ���û����
[~,tmp_idx_o2n,tmp_idx_n2o]=unique(t_bikeid_M); %ֻ��һ��һ����жϣ�
FLG=zeros(length(tmp_idx_o2n),1);

for counterM=1:length(tmp_idx_o2n)
    [~,tmp_idx_long,~]=unique(t_long_M(tmp_idx_n2o==counterM));
    tmp_zone_idx=t_zone_idx_M(tmp_idx_n2o==counterM);
    flg=length(tmp_idx_long)-1;%�������ı䣬flg>0
    FLG(counterM)=flg;
    if flg
        for ii=1:length(tmp_idx_long)-1
            %�Լ�
%             disp(num2str(ii))
            OD_M(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))=OD_M(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))+1;%������ڶԵ�OD�OD������
        end
    end
end
% ʹ���� 1-length(find(FLG==0))/length(FLG)
% �Խ�������
OD_M=sparse(OD_M);
OD_M=OD_M+diag(-diag(OD_M));
%--------------------------�ظ�����A��N��-----------------------
OD_A=zeros(10000,10000); %�����ΪO �����ΪD �Խ���û����
[~,tmp_idx_o2n,tmp_idx_n2o]=unique(t_bikeid_A);
FLG=zeros(length(tmp_idx_o2n),1);
for counterA=1:length(tmp_idx_o2n)
    [~,tmp_idx_long,~]=unique(t_long_A(tmp_idx_n2o==counterA));
    tmp_zone_idx=t_zone_idx_A(tmp_idx_n2o==counterA);
    flg=length(tmp_idx_long)-1;%�������ı䣬flg>0
    FLG(counterA)=flg;
    if flg
        for ii=1:length(tmp_idx_long)-1
            %�Լ�
%             disp(num2str(ii))
            OD_A(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))=OD_A(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))+1;%������ڶԵ�OD�OD������
        end
    end
end
% ʹ���� 1-length(find(FLG==0))/length(FLG)
% �Խ�������
OD_A=sparse(OD_A);
OD_A=OD_A+diag(-diag(OD_A));

OD_N=zeros(10000,10000); %�����ΪO �����ΪD �Խ���û����
[~,tmp_idx_o2n,tmp_idx_n2o]=unique(t_bikeid_N);
FLG=zeros(length(tmp_idx_o2n),1);
for counterN=1:length(tmp_idx_o2n)
    [~,tmp_idx_long,~]=unique(t_long_N(tmp_idx_n2o==counterN));
    tmp_zone_idx=t_zone_idx_N(tmp_idx_n2o==counterN);
    flg=length(tmp_idx_long)-1;%�������ı䣬flg>0
    FLG(counterN)=flg;
    if flg
        for ii=1:(length(tmp_idx_long)-1)
            %�Լ�
%             disp(num2str(ii))
            OD_N(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))=OD_N(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))+1;%������ڶԵ�OD�OD������
        end
    end
end
% ʹ���� 1-length(find(FLG==0))/length(FLG)
% �Խ�������
OD_N=sparse(OD_N);
OD_N=OD_N+diag(-diag(OD_N));

%����OD_MAN_all
OD_M_all=OD_M_all+OD_M;
OD_A_all=OD_A_all+OD_A;
OD_N_all=OD_N_all+OD_N;
dataStore_all=[dataStore_all;dataStore];
%---------������2017-10-06
disp(['��' num2str(counter_Folder-2) '���ļ����������'])
for i=1:length(t_zone_idx_M)
    Supply_M_all(t_zone_idx_M(i),1)=Supply_M_all(t_zone_idx_M(i),1)+1;
end
for i=1:length(t_zone_idx_A)
    Supply_A_all(t_zone_idx_A(i),1)=Supply_A_all(t_zone_idx_A(i),1)+1;
end
for i=1:length(t_zone_idx_N)
    Supply_N_all(t_zone_idx_N(i),1)=Supply_N_all(t_zone_idx_N(i),1)+1;
end
%-----------
% disp(['Processing...' num2str(  (counter_Folder-2)/(size(Dir_Stru,1)-2) ) 'is done'])
waitbar((counter_Folder-2)/(size(Dir_Stru,1)-2))
end
delete(Bar_Handler)
clear Bar_Handler OD_M OD_A OD_N

%% -----------------����ģ�黯����/�ڽ��Ⱦ��� ����Louvain�㷨--------------
% Louvain �㷨----------
for LV_counter=['M','A','N']
       eval( ['k = full(sum(OD_' LV_counter '_all));'] );
       twom = sum(k);
       eval(['B=OD_' LV_counter  '_all-k''*k/twom;']);%B��adjacency matrix
       B=sparse(B);%ϡ�軯�Ժ��ٶ���߲���һ��㣡����
        [S,Q] = genlouvain(B);
        Q = Q/twom
  
%S�ı�Ǿ���10000��node����Ӧ��community        
tt=tabulate(S);
LV_zone_cmt=[];
for ii=tt(tt(:,2)>1,1)'%����������ϵ�Ķ�
tmp_LV_cmt=find(S==ii);
LV_zone_cmt=[LV_zone_cmt;[tmp_LV_cmt,ii*ones(size(tmp_LV_cmt))]];
end
%�����ͬʱ��ε��������
writetable(table(LV_zone_cmt(:,1),LV_zone_cmt(:,2),'VariableNames',{'ZoneIdx','Community'}),['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\LouvainOutput_minhang\' dtNum 'OD_' LV_counter '.csv'])
eval([LV_counter  '=LV_zone_cmt(:,1);']);
eval([LV_counter '_cmt=LV_zone_cmt(:,2);'])
disp([LV_counter 'finished'])
end 
% Lovain �㷨END------------
b=[M;A;N];%M,A,NΪ������������ϵ����������������������դ�������е�դ�������ż�
c=[M_cmt;A_cmt;N_cmt];%M_cmt,A_cmt,N_cmtΪ������������ϵ���������������
LV_Output=table(b,c,'VariableNames',{'ZoneIdx','Community'});
writetable(LV_Output,['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\LouvainOutput_minhang\' dtNum '.csv'])
clear b c M A N M_cmt A_cmt N_cmt LV_zone_cmt

%% 10000����ת��Ϊ��άƽ�沢��ʵ�ֳ����Ŀ��ӻ�
%�����O��
% for ii=['M','A','N']
SJTU_map=imread('F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\ArcGis_Vis_Test\LongLat_PS\��Ʒ1.png');
% ͸����������
% [m1,n1,l1]=size(SJTU_map);
% t_map=zeros(m1,n1,l1);
% t_map=uint8(t_map);
% C=imadd(0.5*t_map,SJTU_map);
% imshow(C)
for ii=['M','A','N']
eval(['OD_sumO_' ii '=sum(OD_' ii '_all,2);']); %2�����ͼ,1���յ�ͼ
eval(['demand=vec2mat(  OD_sumO_' ii ',100);'])
demand=demand';

%---------������2017-10-06
eval(['supply=vec2mat(  Supply_' ii '_all,100);'])
supply=supply';
%------------

% figure
[x_map,y_map,~]=size(SJTU_map);


% colormap jet
DrawMap(demand,['Demand_' ii])
% s=surf(linspace(1,y_map,100),linspace(1,x_map,100),0*demand,demand);
% shading interp
% view(2)
% alpha(s,.5)
% title(['Supply&Demand_' ii])

% colormap bone
DrawMap(supply,['Supply_' ii])
% q=surf(linspace(1,y_map,100),linspace(1,x_map,100),0*supply,supply);
% shading interp
% view(2)
% alpha(q,.5)
% title(['Supply&Demand_' ii])


% imshow(SJTU_map)
% hold on
supply_minus_demand=supply-demand;
demand_minus_supply=-supply_minus_demand;
DrawMap(supply_minus_demand,['SupplyMinusDemand_' ii])
% q=surf(linspace(1,y_map,100),linspace(1,x_map,100),0*demand_minus_supply,demand_minus_supply);
% shading interp
% view(2)
% alpha(q,.5)

hold off
% title(['Supply&Demand_' ii])
clear x_map y_map 

end
%% �������һ������ĵ�����Ͷ�����Ƿ��㹻���أ�Louvainֻ�Ƿ�ӳ������������ϵ�ȽϽ��ܵ�OD�ԣ������ڲ�ͬʱ�����
%Ͷ��������Ҫ�ﵽ���ٵ���ֵ�����������㹻���أ��Ƿ����ÿ��community��ƽ��Ͷ���������м��㣿
%�Ȳ鿴Louvain�����ܳ����Ժ��������Щ����,�����ڵ����ϵķֲ���ε�
%��Щ�������������������
%��λ��һֱ�����ĳ������ǽ�ȥ�������������community��������ʱ��Σ�������ݲ����Ļ�����MAN�������������ģ�����&����ĳ�����Ŀ
%�������Ԥ��ֵ������Ҫ��community�е�������������೵�Ļ������ã����community������Ҳ�����Ļ���������������������Ƿḻ��
%community�еĳ���

%-----------Louvain�����ܳ����������ֲ�--------------
SJTU_map=imread('F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\ArcGis_Vis_Test\LongLat_PS\��Ʒ1.png');
Cap_Vec=sparse(zeros(1,10000));
Cap_Vec(LV_Output.ZoneIdx)=1;
Cap_Mat=vec2mat(Cap_Vec,100);
Cap_Mat=Cap_Mat';

figure
[x_map,y_map,~]=size(SJTU_map);
imshow(SJTU_map)
hold on
s=surf(linspace(1,y_map,100),linspace(1,x_map,100),0*Cap_Mat,Cap_Mat);
shading interp
view(2)
hold off
alpha(s,.5)
title('LouvainCommunityDistribution')
clear x_map y_map s Cap_Vec Cap_Mat
%-----END------Louvain�����ܳ����������ֲ�------END--------
%% --------------����������Ĺ����ϵ-----------------
%��Ͷ������ת��Ϊ�����ϵ������
%OD_sumO_MAN��û�п��ǵ�ʱ�䣬��ô����Ӧ����ν����
%��������ԭ���ط��ĳ���������+���ⲿ����ĳ��ӣ��㷨��

%��ͬʱ��εĳ����ֲ�
Supp_hist=zeros(24-6+1,1);
tmp=tabulate(dataStore_all.Time);
for counter=6:23
    for ii=1:size(tmp,1)
        tmp_reg=regexp(tmp{ii,1},':','split');
        if  str2double(tmp_reg{1})==counter
            Supp_hist(counter-5,1)=tmp{ii,2};
        end
    end
end
 for ii=1:size(tmp,1)
        tmp_reg=regexp(tmp{ii,1},':','split');
        if  str2double(tmp_reg{1})==0
            Supp_hist(19,1)=tmp{ii,2};
        end
 end
bar([6:24],Supp_hist)
clear counter tmp ii tmp_reg
% Supp_Vec=sparse(zeros(1,10000));
%% ͬһ��������������һЩ����

detector_cmt=length(LV_Output_cmt_uniq);
if ~exist([Output_image '\' num2str(width) '_' num2str(height)])
    mkdir([Output_image '\' num2str(width) '_' num2str(height)])
end
Louvaincmt_video=VideoWriter([Output_image '\' num2str(width) '_' num2str(height) ' LouvainCmt.avi' ]);
Louvaincmt_video.FrameRate=2;
open(Louvaincmt_video)
for ii=1:detector_cmt
[LV_Output_cmt_uniq,idx_LV_o2n,idx_LV_n2o]=unique(LV_Output.Community);
Cmt_Vec=sparse(zeros(1,GridsNum));
Cmt_Vec(LV_Output.ZoneIdx(idx_LV_n2o==ii))=1; %�������������Ҫ�鿴�Ĳ�ͬ��������ţ����Է�������˼��������2��
Cmt_Mat=vec2mat(Cmt_Vec,height);
Cmt_Mat=Cmt_Mat';
[frame,handler]=DrawMap(Cmt_Mat,[num2str(width) '*' num2str(height) ' MinhangLouvainCmtDistribution No.' num2str(ii)],width,height);
writeVideo(Louvaincmt_video,frame)
print( [Output_image '\' num2str(width) '_' num2str(height) '\LouvainCmtDistribution_' num2str(ii)],'-dpng'  )
close(handler)
end
clear frame
close(Louvaincmt_video)
close all %�ص�����figure

%{
%% ��ʼ��֤ģ�͵�׼ȷ�� Part 1/2��Ԥ����ܴ��ڵĺ��������ֻ�ж��Ƿ�Ϊ������������������ﲻ��������
% �����������
dataStore_hour=cell(24-6+1,1);
%��ʼ��Сʱ����
for i=1:size(dataStore_hour,1)
    dataStore_hour{i,1}=sparse(zeros(1,10000));
end

%----������2017-10-06
%���Ƕ��ȶ�dataStore_all����λ���ϵ�ȡ��,��Ϊ��������Ӧ��Ӧ���Ǹ�������ϳ�����O��
[~,idx_hour_uniq,~]=unique(dataStore_all.Long);
dataStore_all_demand=dataStore_all(idx_hour_uniq,:);
%------------

clear i
Bar_Handler=waitbar(0,'���ڲ���ÿ��Сʱ��ÿ�������������dataStore_hour....');
% Ҫ��ZoneIdxΪ0�������޳�
for bigCounter=1:(size(dataStore_hour,1)-1)       
    for biggestCounter=1:size(dataStore_all_demand.Time,1)
        tmp_reg=regexp(dataStore_all_demand.Time{biggestCounter,1},':','split');
            if  str2double(tmp_reg{1})==(bigCounter+5)&&dataStore_all_demand.ZoneIdx(biggestCounter)~=0
                dataStore_hour{bigCounter,1}(1,dataStore_all_demand.ZoneIdx(biggestCounter))=...
                    dataStore_hour{bigCounter,1}(1,dataStore_all_demand.ZoneIdx(biggestCounter))+1;
            end
    end
waitbar(bigCounter/(size(dataStore_hour,1)-1))
end
delete(Bar_Handler)
clear bigCounter biggestCounter Bar_Handler
%0��Ҫ��������
 for biggestCounter=1:size(dataStore_all_demand.Time,1)
        tmp_reg=regexp(dataStore_all_demand.Time{biggestCounter,1},':','split');
            if  str2double(tmp_reg{1})==0&&dataStore_all_demand.ZoneIdx(biggestCounter)~=0
                dataStore_hour{end,1}(1,dataStore_all_demand.ZoneIdx(biggestCounter))=...
                    dataStore_hour{end,1}(1,dataStore_all_demand.ZoneIdx(biggestCounter))+1;
            end
 end
 clear biggestCounter
 save dataStore_hour_origin dataStore_hour
 disp('ÿ��Сʱ��ÿ��������������Ѿ���ɲ���')
% �������ע���
load dataStore_hour_origin.mat
for i=1:length(dataStore_hour)
    disp([num2str(i) '��max' num2str(max(dataStore_hour{i,1}))])
end
%% ���������Լ�������������ж� Part 2/2
%�ȸ���ÿ��ʱ�������
load dataStore_hour_origin.mat
fileNum=size(Dir_Stru,1)-2;
Not_Cmt=setxor(1:10000,LV_Output.ZoneIdx);
Bar_Handler=waitbar(0,'���ڲ�����ֵϡ�����,����Դ��������������ע�⣡��ʱdataStore_hour����Ϊ����������....');
for counter_hour=1:size(dataStore_hour,1)
    %�Ȱ��������ҳ���������ƽ��,��ʵƽ����������õ�ѡ����Ϊ���ж�һ�������Ƿ��㹻��Ӧ�ÿ��������������ڵ������Ƿ��㹻
    %�������ǻ���ʹ������������/�ļ�����Ϊ��ֵ�������һ�����򱻶������ռ�ã�����ӣ�����ķ����������ֱ��ƽ��
    for counter_cmt=1:size(LV_Output_cmt_uniq,1)
        %ԭ���������ʽ�����г���fileNum �������ڸĳ�ÿ��������ܺ�֮���ٳ���fileNum
        %����ÿ��ѭ������fileNum�ȽϺã���Ȼ�������õĽڵ�̫������ ÿ�α�����fileNum ָ��������
        dataStore_hour{counter_hour,1}(1,LV_Output.ZoneIdx(idx_LV_n2o==counter_cmt))...
            =sum(dataStore_hour{counter_hour,1}(1,LV_Output.ZoneIdx(idx_LV_n2o==counter_cmt)))/(fileNum);%9.23���£������������������ƽ��
%         dataStore_hour{counter_hour,1}(1,LV_Output.ZoneIdx(idx_LV_n2o==counter_cmt))=...
%             sum(dataStore_hour{counter_hour,1}(1,LV_Output.ZoneIdx(idx_LV_n2o==counter_cmt)))/(sum(idx_LV_n2o==counter_cmt));%9.23���£������������������ƽ��
%  ֢�ᱻ�ҵ��ˣ���Ϊ������̫С�����·��ӵ������ڵĵ�������ʵ�ͷ�ĸ�������ڽڵ���Ŀ���
% tabulate(idx_LV_n2o)
    end
        %����������ͨ��setxorֱ�ӳ����ļ��� size(Dir_Stru)-2    
%         dataStore_hour{counter_hour,1}(1,Not_Cmt)=dataStore_hour{counter_hour,1}(1,Not_Cmt)/fileNum;
% 9.23���� ��fileNum��Ϊͳһ�ķ�ĸ
%         dataStore_hour{counter_hour,1}(1,:)=dataStore_hour{counter_hour,1}(1,:)/fileNum;
        dataStore_hour{counter_hour,1}(1,:)=dataStore_hour{counter_hour,1}(1,:)/fileNum;
        waitbar(counter_hour/size(dataStore_hour,1))       
end
delete(Bar_Handler)
% clear fileNum counter_hour counter_cmt Bar_Handler
% save Threshold_hour_cell_cmt dataStore_hour
for i=1:length(dataStore_hour)
    disp([num2str(i) '��  �����ֵΪ' num2str(max(dataStore_hour{i,1})) 'ƽ����ֵΪ' num2str(mean(dataStore_hour{i,1}))])
end

%% �͹ٷ����ĺ�������бȽ�
%Ҫ����һ��ĵ������ݣ�
%�ٷ����ĺ����Ϊ
%��9��4�յ����ݽ�����֤
Directory_Test=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\TestData'];

ds=datastore([Directory_Test '\' '20170904.csv'],...
    'VariableNames',VariableNames,'TextscanFormats',TextscanFormats,'IncludeSubfolders',false,'FileExtensions','.csv'...
    ,'Type','tabulartext');
data_Test=readall(ds);

t_long=data_Test.Long; %t_long��t_lat��ֻ�ǲ�����;
t_lat=data_Test.Lat;
t_bikeid=data_Test.bikeIds;
% �ȼ�໮���������꣬�õ�һ��100*100�Ĵ����
t_long_idx=zeros(length(t_long),1);
t_lat_idx=zeros(length(t_lat),1);
t_zone_idx=zeros(length(t_lat),1);
for counter=1:length(t_long_idx)
    tmp_lng=find(zone_long>=t_long(counter));%ֻ�е�һ����������Ҫ��,������Ƚ��٣������������
    tmp_lat=find(zone_lat>=t_lat(counter));
    if ~isempty(tmp_lng)&&~isempty(tmp_lat)
    t_long_idx(counter)=tmp_lng(1)-1;%��ӳ����������������������Ļ��ֵ�
    t_lat_idx(counter)=tmp_lat(1)-1;
    end
end
clear tmp_lat tmp_lng counter
tmp_zone_idx=find(t_long_idx>0&t_lat_idx>0);
t_zone_idx(tmp_zone_idx)=(t_long_idx(tmp_zone_idx)-1)*100+101-t_lat_idx(tmp_zone_idx);%0��ʾ���ڻ��ֵ������д��������������µ��� ������������ʽ������������һ��
clear tmp_zone_idx
data_Test.ZoneIdx=t_zone_idx;%������������ӵ�����
clear t_long t_lat t_bikeid t_long_idx t_lat_idx t_zone_idx

idx_RedPac=find(data_Test.biketype==999&data_Test.ZoneIdx>0);
dataStore_RedPac=table(data_Test.bikeIds(idx_RedPac),data_Test.Time(idx_RedPac),data_Test.ZoneIdx(idx_RedPac),'VariableNames',{'bikeIds','Time','ZoneIdx'});
% �о���֤������ĳ����ֲ���Ӧ�ò����ĺ����bikeId��ٷ�����ID���غ϶�
% Valid_Table=table();
Valid_Result=dataStore_hour;
for counter_hour=1:(size(Valid_Result,1)-1) 
    for counter_TestSize=1:size(data_Test.Time,1)
         tmp_reg=regexp(data_Test.Time{counter_TestSize,1},':','split');
            if  str2double(tmp_reg{1})==(counter_hour+5)&&data_Test.ZoneIdx(counter_TestSize)~=0
                Valid_Result{counter_hour,1}(1,data_Test.ZoneIdx(counter_TestSize))=...
                    Valid_Result{counter_hour,1}(1,data_Test.ZoneIdx(counter_TestSize))-1;
            end
    end
disp(['��֤��������ɶ�' num2str(counter_hour/size(Valid_Result,1)) '...'] )
end
for counter_TestSize=1:size(data_Test.Time,1)
     tmp_reg=regexp(data_Test.Time{counter_TestSize,1},':','split');
            if  str2double(tmp_reg{1})==0&&data_Test.ZoneIdx(counter_TestSize)~=0
                Valid_Result{end,1}(1,data_Test.ZoneIdx(counter_TestSize))=...
                    Valid_Result{end,1}(1,data_Test.ZoneIdx(counter_TestSize))-1;
            end
end
disp('��֤�����������')
clear counter_hour counter_TestSize
% ����ֻ��Ҫ����ÿ��Сʱ�к������ZoneIdx�Ƿ��С��0������һ��������˵���ص��̶�
Intersect_Counter_all=0;
%ÿ��Сʱ�غ������
for counter_IntSec=1:(size(Valid_Result,1)-1)
   Intersect_Counter=0;
   RedPac_Hour_Counter=0;
   Pred_RedPac=find(Valid_Result{counter_IntSec,1}<0);%1*n������
%    %��ͼר��
    Pred_Vec=sparse(zeros(1,10000));
    Pred_Vec(1,Pred_RedPac)=Pred_Vec(1,Pred_RedPac)+1;
      RedPac_Vec=sparse(zeros(1,10000));
    
   for counter_RedPac=1:size(dataStore_RedPac.Time,1)
     tmp_reg=regexp(dataStore_RedPac.Time{counter_RedPac,1},':','split');
            if  str2double(tmp_reg{1})==(counter_IntSec+5)&&dataStore_RedPac.ZoneIdx(counter_RedPac)~=0 %��ʵǰ���Ѿ��жϹ���
                 Intersect_Counter= Intersect_Counter + ...
                     size(   intersect(Pred_RedPac, dataStore_RedPac.ZoneIdx(counter_RedPac))  ,2);
                 
                 RedPac_Hour_Counter=RedPac_Hour_Counter+1;
%                  %��ͼ��
                 RedPac_Vec(1,dataStore_RedPac.ZoneIdx(counter_RedPac))=Pred_Vec(1,dataStore_RedPac.ZoneIdx(counter_RedPac))+1;
            end
   end
    Intersect_Counter_all=Intersect_Counter_all+Intersect_Counter;
    disp([num2str(counter_IntSec+5) 'ʱԤ��ֵ�������ص���' num2str(Intersect_Counter) '    [*]ռԤ��ֵ' num2str(Intersect_Counter/size(Pred_RedPac,2))...
        '    [**]ռ�������' num2str(Intersect_Counter/ RedPac_Hour_Counter)])
    %��ͼ
    Pred_Mat=vec2mat(Pred_Vec,100);
    Pred_Mat=Pred_Mat';
    DrawMap(Pred_Mat,['RedPac Bike Prediction' num2str(counter_IntSec+5) 'ʱ'])
    RedPac_Mat=vec2mat(RedPac_Vec,100);
    RedPac_Mat=RedPac_Mat';
    DrawMap(RedPac_Mat,['RedPac Bike Original Distribution' num2str(counter_IntSec+5) 'ʱ'])
end
for counter_IntSec=0
   Intersect_Counter=0;
   RedPac_Hour_Counter=0;
   Pred_RedPac=find(Valid_Result{end,1}<0);%1*n������
   for counter_RedPac=1:size(dataStore_RedPac.Time,1)
     tmp_reg=regexp(dataStore_RedPac.Time{counter_RedPac,1},':','split');
            if  str2double(tmp_reg{1})==(counter_IntSec)&&dataStore_RedPac.ZoneIdx(counter_RedPac)~=0 %��ʵǰ���Ѿ��жϹ���
                 Intersect_Counter= Intersect_Counter + ...
                     size(   intersect(Pred_RedPac, dataStore_RedPac.ZoneIdx(counter_RedPac))  ,2);
                 
                 RedPac_Hour_Counter=RedPac_Hour_Counter+1;
            end
   end
    Intersect_Counter_all=Intersect_Counter_all+Intersect_Counter;
    disp([num2str(counter_IntSec) 'ʱԤ��ֵ�������ص���' num2str(Intersect_Counter) '    [*]ռԤ��ֵ' num2str(Intersect_Counter/size(Pred_RedPac,2))...
        '    [**]ռ�������' num2str(Intersect_Counter/ RedPac_Hour_Counter)])
end
%}