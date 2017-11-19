clc
% 需要定义全局的变量
width=100;
height=100;
GridsNum=width*height;


%% --------------Ingestion----------------------
VariableNames={'bikeIds','Long','Lat','biketype','Time'};
TextscanFormats={'%s','%.15f', '%.15f' ,'%u' ,'%s'};
dtNum='Test4All'; %方便维护代码
Directory=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\Data'];
Output_image='F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\Output_image_minhang';
Dir_Stru=dir(Directory);
%由于需要读取每一个文件以后再进行合并OD_MAN，所以现在这里初始化
OD_M_all=sparse(zeros(10000,10000)); %纵向↓为O 横向→为D 对角线没意义
OD_A_all=sparse(zeros(10000,10000)); %纵向↓为O 横向→为D 对角线没意义
OD_N_all=sparse(zeros(10000,10000)); %纵向↓为O 横向→为D 对角线没意义
%----更新于1017-10-06
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
t_long=dataStore.Long; %t_long与t_lat都只是测试用途
t_lat=dataStore.Lat;
t_bikeid=dataStore.bikeIds;
% 等间距划分区域坐标，得到一个100*100的大矩阵
zone_long=linspace(121.4206362038,121.4680599309,101);%是101而不是100！
zone_lat=linspace(31.0202935288,31.0454378038,101);
t_long_idx=zeros(length(t_long),1);
t_lat_idx=zeros(length(t_lat),1);
t_zone_idx=zeros(length(t_lat),1);
for counter=1:length(t_long_idx)
    tmp_lng=find(zone_long>=t_long(counter));%只有第一项是我们需要的,等于项比较少？归入大于项中
    tmp_lat=find(zone_lat>=t_lat(counter));
    if ~isempty(tmp_lng)&&~isempty(tmp_lat)
    t_long_idx(counter)=tmp_lng(1)-1;%反映的是所属区间而不是所属的划分点
    t_lat_idx(counter)=tmp_lat(1)-1;
    end
end
clear tmp_lat tmp_lng counter
tmp_zone_idx=find(t_long_idx>0&t_lat_idx>0);
t_zone_idx(tmp_zone_idx)=(t_long_idx(tmp_zone_idx)-1)*100+101-t_lat_idx(tmp_zone_idx);%0表示不在划分的区域中从左上序数往右下递增 ↓↓↓这种形式，矩阵列向量一样
clear tmp_zone_idx
dataStore.ZoneIdx=t_zone_idx;%将所属区域添加到表中
% Write Table or not
%% 开始处理OD矩阵
%先对时间顺序进行处理
t_time=dataStore.Time;
for counter_time=1:length(t_time)
    tmp_time=t_time{counter_time};
    tmp_reg=regexp(tmp_time,':','split');
    t_time{counter_time}=str2double(tmp_reg{1});
end
clear tmp_time tmp_reg counter_time
t_time=cell2mat(t_time);
[t_time,idx_time]=sort(t_time);%idx_time是按照时间排序以后的,保证后面的M A N得到的idx_time也是顺序的
%% 后面有用的变量在这里按时间排序
t_long=t_long(idx_time);
t_lat=t_lat(idx_time);
t_bikeid=t_bikeid(idx_time);
t_zone_idx=t_zone_idx(idx_time);
%变量约束在我们研究的范围内
t_long=t_long(t_zone_idx>0);
t_lat=t_lat(t_zone_idx>0);
t_bikeid=t_bikeid(t_zone_idx>0);
t_time=t_time(t_zone_idx>0);
t_zone_idx=t_zone_idx(t_zone_idx>0);
%biketype=biketype(idx_time)
% clear idx_time
%按照早中晚等切分时间段
%初步考虑是 上午+中午（6:00-13:00）M  下午到傍晚（14:00-18:00）A  晚上（19:00-00:00）N
idx_time_M=find(t_time>0&t_time<=13);   
idx_time_A=find(t_time>13&t_time<=18);
idx_time_N=find(t_time>18&t_time<=23|t_time==0);
%开始生成各自的O-D矩阵
%%先取出各自时间段的经纬度以及ID
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





%对每个时间段中的bikeids去重，返回到经纬度中看看是否有位置上的改变，如果有则记录他们的OD 
%此中是否需要MATLAB图论的知识？
%和亢男学长讨论完，这个就是一个网络的问题
%考虑将MAN三个时间段中以bikeids为切入点，判断相应的经纬度改变是否改变，进而按照时间顺序构建OD矩阵，OD矩阵为切分的100*100的square但是asymmetric（有向）
%% 先对morning进行处理，以下处理都只能针对一天的三个时间段
OD_M=zeros(10000,10000); %纵向↓为O 横向→为D 对角线没意义
[~,tmp_idx_o2n,tmp_idx_n2o]=unique(t_bikeid_M); %只能一天一天地判断！
FLG=zeros(length(tmp_idx_o2n),1);

for counterM=1:length(tmp_idx_o2n)
    [~,tmp_idx_long,~]=unique(t_long_M(tmp_idx_n2o==counterM));
    tmp_zone_idx=t_zone_idx_M(tmp_idx_n2o==counterM);
    flg=length(tmp_idx_long)-1;%如果坐标改变，flg>0
    FLG(counterM)=flg;
    if flg
        for ii=1:length(tmp_idx_long)-1
            %自加
%             disp(num2str(ii))
            OD_M(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))=OD_M(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))+1;%算出相邻对的OD填到OD矩阵上
        end
    end
end
% 使用率 1-length(find(FLG==0))/length(FLG)
% 对角线清零
OD_M=sparse(OD_M);
OD_M=OD_M+diag(-diag(OD_M));
%--------------------------重复生成A和N的-----------------------
OD_A=zeros(10000,10000); %纵向↓为O 横向→为D 对角线没意义
[~,tmp_idx_o2n,tmp_idx_n2o]=unique(t_bikeid_A);
FLG=zeros(length(tmp_idx_o2n),1);
for counterA=1:length(tmp_idx_o2n)
    [~,tmp_idx_long,~]=unique(t_long_A(tmp_idx_n2o==counterA));
    tmp_zone_idx=t_zone_idx_A(tmp_idx_n2o==counterA);
    flg=length(tmp_idx_long)-1;%如果坐标改变，flg>0
    FLG(counterA)=flg;
    if flg
        for ii=1:length(tmp_idx_long)-1
            %自加
%             disp(num2str(ii))
            OD_A(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))=OD_A(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))+1;%算出相邻对的OD填到OD矩阵上
        end
    end
end
% 使用率 1-length(find(FLG==0))/length(FLG)
% 对角线清零
OD_A=sparse(OD_A);
OD_A=OD_A+diag(-diag(OD_A));

OD_N=zeros(10000,10000); %纵向↓为O 横向→为D 对角线没意义
[~,tmp_idx_o2n,tmp_idx_n2o]=unique(t_bikeid_N);
FLG=zeros(length(tmp_idx_o2n),1);
for counterN=1:length(tmp_idx_o2n)
    [~,tmp_idx_long,~]=unique(t_long_N(tmp_idx_n2o==counterN));
    tmp_zone_idx=t_zone_idx_N(tmp_idx_n2o==counterN);
    flg=length(tmp_idx_long)-1;%如果坐标改变，flg>0
    FLG(counterN)=flg;
    if flg
        for ii=1:(length(tmp_idx_long)-1)
            %自加
%             disp(num2str(ii))
            OD_N(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))=OD_N(tmp_zone_idx(tmp_idx_long(ii)),tmp_zone_idx(tmp_idx_long(ii+1)))+1;%算出相邻对的OD填到OD矩阵上
        end
    end
end
% 使用率 1-length(find(FLG==0))/length(FLG)
% 对角线清零
OD_N=sparse(OD_N);
OD_N=OD_N+diag(-diag(OD_N));

%更新OD_MAN_all
OD_M_all=OD_M_all+OD_M;
OD_A_all=OD_A_all+OD_A;
OD_N_all=OD_N_all+OD_N;
dataStore_all=[dataStore_all;dataStore];
%---------更新于2017-10-06
disp(['第' num2str(counter_Folder-2) '个文件的需求矩阵'])
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

%% -----------------生成模块化矩阵/邻近度矩阵 进而Louvain算法--------------
% Louvain 算法----------
for LV_counter=['M','A','N']
       eval( ['k = full(sum(OD_' LV_counter '_all));'] );
       twom = sum(k);
       eval(['B=OD_' LV_counter  '_all-k''*k/twom;']);%B是adjacency matrix
       B=sparse(B);%稀疏化以后速度提高不是一点点！！！
        [S,Q] = genlouvain(B);
        Q = Q/twom
  
%S的标记就是10000个node所对应的community        
tt=tabulate(S);
LV_zone_cmt=[];
for ii=tt(tt(:,2)>1,1)'%存在社区联系的对
tmp_LV_cmt=find(S==ii);
LV_zone_cmt=[LV_zone_cmt;[tmp_LV_cmt,ii*ones(size(tmp_LV_cmt))]];
end
%输出不同时间段的社区标号
writetable(table(LV_zone_cmt(:,1),LV_zone_cmt(:,2),'VariableNames',{'ZoneIdx','Community'}),['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\LouvainOutput_minhang\' dtNum 'OD_' LV_counter '.csv'])
eval([LV_counter  '=LV_zone_cmt(:,1);']);
eval([LV_counter '_cmt=LV_zone_cmt(:,2);'])
disp([LV_counter 'finished'])
end 
% Lovain 算法END------------
b=[M;A;N];%M,A,N为早中晚中有联系的社区（社区中至少两个栅格区域）中的栅格区域编号集
c=[M_cmt;A_cmt;N_cmt];%M_cmt,A_cmt,N_cmt为早中晚中有联系的社区的社区编号
LV_Output=table(b,c,'VariableNames',{'ZoneIdx','Community'});
writetable(LV_Output,['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\LouvainOutput_minhang\' dtNum '.csv'])
clear b c M A N M_cmt A_cmt N_cmt LV_zone_cmt

%% 10000序数转化为二维平面并且实现初步的可视化
%先针对O点
% for ii=['M','A','N']
SJTU_map=imread('F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\ArcGis_Vis_Test\LongLat_PS\成品1.png');
% 透明化处理尝试
% [m1,n1,l1]=size(SJTU_map);
% t_map=zeros(m1,n1,l1);
% t_map=uint8(t_map);
% C=imadd(0.5*t_map,SJTU_map);
% imshow(C)
for ii=['M','A','N']
eval(['OD_sumO_' ii '=sum(OD_' ii '_all,2);']); %2是起点图,1是终点图
eval(['demand=vec2mat(  OD_sumO_' ii ',100);'])
demand=demand';

%---------更新与2017-10-06
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
%% 如何评价一个区域的单车额投放量是否足够了呢？Louvain只是反映了这个区域的联系比较紧密的OD对，但是在不同时间段下
%投放量究竟要达到多少的阈值才能算作是足够了呢？是否根据每个community的平均投放量来进行计算？
%先查看Louvain方法跑出来以后基本是哪些社区,它们在地理上的分布如何的
%这些社区的流量（需求）如何
%把位置一直不动的车辆考虑进去，对于流量大的community，看各个时间段（如果数据不够的话就用MAN代替分析结果）的，社区&区域的车辆数目
%如果低于预期值，则需要由community中的其他区域（如果多车的话）调用，如果community中其他也不够的话，则调用其他低流量但是丰富的
%community中的车辆

%-----------Louvain方法跑出来的社区分布--------------
SJTU_map=imread('F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\ArcGis_Vis_Test\LongLat_PS\成品1.png');
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
%-----END------Louvain方法跑出来的社区分布------END--------
%% --------------社区内区域的供需关系-----------------
%将投放问题转化为供需关系的问题
%OD_sumO_MAN并没有考虑到时间，那么需求应该如何解决？
%供给就是原来地方的车（好做）+从外部调入的车子（算法）

%不同时间段的车辆分布
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
%% 同一个社区究竟是哪一些区域

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
Cmt_Vec(LV_Output.ZoneIdx(idx_LV_n2o==ii))=1; %可以在这里更换要查看的不同的社区编号，可以发现有意思的区域，如2，
Cmt_Mat=vec2mat(Cmt_Vec,height);
Cmt_Mat=Cmt_Mat';
[frame,handler]=DrawMap(Cmt_Mat,[num2str(width) '*' num2str(height) ' MinhangLouvainCmtDistribution No.' num2str(ii)],width,height);
writeVideo(Louvaincmt_video,frame)
print( [Output_image '\' num2str(width) '_' num2str(height) '\LouvainCmtDistribution_' num2str(ii)],'-dpng'  )
close(handler)
end
clear frame
close(Louvaincmt_video)
close all %关掉所有figure

%{
%% 开始验证模型的准确性 Part 1/2（预测可能存在的红包车），只判断是否为红包车，具体红包到哪里不予以讨论
% 先求出供给量
dataStore_hour=cell(24-6+1,1);
%初始化小时数组
for i=1:size(dataStore_hour,1)
    dataStore_hour{i,1}=sparse(zeros(1,10000));
end

%----更新于2017-10-06
%考虑对先对dataStore_all进行位置上的取独,因为需求量反应的应当是该区域的上车数（O）
[~,idx_hour_uniq,~]=unique(dataStore_all.Long);
dataStore_all_demand=dataStore_all(idx_hour_uniq,:);
%------------

clear i
Bar_Handler=waitbar(0,'正在产生每个小时下每个区域的需求量dataStore_hour....');
% 要把ZoneIdx为0的区域剔除
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
%0点要单独讨论
 for biggestCounter=1:size(dataStore_all_demand.Time,1)
        tmp_reg=regexp(dataStore_all_demand.Time{biggestCounter,1},':','split');
            if  str2double(tmp_reg{1})==0&&dataStore_all_demand.ZoneIdx(biggestCounter)~=0
                dataStore_hour{end,1}(1,dataStore_all_demand.ZoneIdx(biggestCounter))=...
                    dataStore_hour{end,1}(1,dataStore_all_demand.ZoneIdx(biggestCounter))+1;
            end
 end
 clear biggestCounter
 save dataStore_hour_origin dataStore_hour
 disp('每个小时下每个区域的需求量已经完成产生')
% 用完可以注解掉
load dataStore_hour_origin.mat
for i=1:length(dataStore_hour)
    disp([num2str(i) '个max' num2str(max(dataStore_hour{i,1}))])
end
%% 根据社区以及单体进行最后的判断 Part 2/2
%先根据每个时间段区分
load dataStore_hour_origin.mat
fileNum=size(Dir_Stru,1)-2;
Not_Cmt=setxor(1:10000,LV_Output.ZoneIdx);
Bar_Handler=waitbar(0,'正在产生阈值稀疏矩阵,区别对待社区与非社区。注意！此时dataStore_hour将成为最后输出变量....');
for counter_hour=1:size(dataStore_hour,1)
    %先把社区的找出来社区内平均,其实平均并不是最好的选择，因为我判断一个社区是否足够更应该看的是整个社区内的总数是否足够
    %经过考虑还是使用社区内总数/文件数作为阈值，如果有一个区域被多个社区占用，则相加，其余的非社区区域就直接平均
    for counter_cmt=1:size(LV_Output_cmt_uniq,1)
        %原来下面这个式子是有除以fileNum 但是现在改成每个都算成总和之后再除以fileNum
        %还是每次循环除以fileNum比较好，不然社区共用的节点太逆天了 每次必须削fileNum 指数级减少
        dataStore_hour{counter_hour,1}(1,LV_Output.ZoneIdx(idx_LV_n2o==counter_cmt))...
            =sum(dataStore_hour{counter_hour,1}(1,LV_Output.ZoneIdx(idx_LV_n2o==counter_cmt)))/(fileNum);%9.23更新，多添加了社区个数的平均
%         dataStore_hour{counter_hour,1}(1,LV_Output.ZoneIdx(idx_LV_n2o==counter_cmt))=...
%             sum(dataStore_hour{counter_hour,1}(1,LV_Output.ZoneIdx(idx_LV_n2o==counter_cmt)))/(sum(idx_LV_n2o==counter_cmt));%9.23更新，多添加了社区个数的平均
%  症结被找到了，因为数据量太小，导致分子的社区内的单车数其实和分母的社区内节点数目差不多
% tabulate(idx_LV_n2o)
    end
        %不在社区的通过setxor直接除以文件数 size(Dir_Stru)-2    
%         dataStore_hour{counter_hour,1}(1,Not_Cmt)=dataStore_hour{counter_hour,1}(1,Not_Cmt)/fileNum;
% 9.23更新 将fileNum作为统一的分母
%         dataStore_hour{counter_hour,1}(1,:)=dataStore_hour{counter_hour,1}(1,:)/fileNum;
        dataStore_hour{counter_hour,1}(1,:)=dataStore_hour{counter_hour,1}(1,:)/fileNum;
        waitbar(counter_hour/size(dataStore_hour,1))       
end
delete(Bar_Handler)
% clear fileNum counter_hour counter_cmt Bar_Handler
% save Threshold_hour_cell_cmt dataStore_hour
for i=1:length(dataStore_hour)
    disp([num2str(i) '个  最大阈值为' num2str(max(dataStore_hour{i,1})) '平均阈值为' num2str(mean(dataStore_hour{i,1}))])
end

%% 和官方给的红包车进行比较
%要拿新一天的单车数据？
%官方给的红包车为
%用9月4日的数据进行验证
Directory_Test=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\TestData'];

ds=datastore([Directory_Test '\' '20170904.csv'],...
    'VariableNames',VariableNames,'TextscanFormats',TextscanFormats,'IncludeSubfolders',false,'FileExtensions','.csv'...
    ,'Type','tabulartext');
data_Test=readall(ds);

t_long=data_Test.Long; %t_long与t_lat都只是测试用途
t_lat=data_Test.Lat;
t_bikeid=data_Test.bikeIds;
% 等间距划分区域坐标，得到一个100*100的大矩阵
t_long_idx=zeros(length(t_long),1);
t_lat_idx=zeros(length(t_lat),1);
t_zone_idx=zeros(length(t_lat),1);
for counter=1:length(t_long_idx)
    tmp_lng=find(zone_long>=t_long(counter));%只有第一项是我们需要的,等于项比较少？归入大于项中
    tmp_lat=find(zone_lat>=t_lat(counter));
    if ~isempty(tmp_lng)&&~isempty(tmp_lat)
    t_long_idx(counter)=tmp_lng(1)-1;%反映的是所属区间而不是所属的划分点
    t_lat_idx(counter)=tmp_lat(1)-1;
    end
end
clear tmp_lat tmp_lng counter
tmp_zone_idx=find(t_long_idx>0&t_lat_idx>0);
t_zone_idx(tmp_zone_idx)=(t_long_idx(tmp_zone_idx)-1)*100+101-t_lat_idx(tmp_zone_idx);%0表示不在划分的区域中从左上序数往右下递增 ↓↓↓这种形式，矩阵列向量一样
clear tmp_zone_idx
data_Test.ZoneIdx=t_zone_idx;%将所属区域添加到表中
clear t_long t_lat t_bikeid t_long_idx t_lat_idx t_zone_idx

idx_RedPac=find(data_Test.biketype==999&data_Test.ZoneIdx>0);
dataStore_RedPac=table(data_Test.bikeIds(idx_RedPac),data_Test.Time(idx_RedPac),data_Test.ZoneIdx(idx_RedPac),'VariableNames',{'bikeIds','Time','ZoneIdx'});
% 研究验证集当天的车辆分布所应该产生的红包车bikeId与官方给出ID的重合度
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
disp(['验证集处理完成度' num2str(counter_hour/size(Valid_Result,1)) '...'] )
end
for counter_TestSize=1:size(data_Test.Time,1)
     tmp_reg=regexp(data_Test.Time{counter_TestSize,1},':','split');
            if  str2double(tmp_reg{1})==0&&data_Test.ZoneIdx(counter_TestSize)~=0
                Valid_Result{end,1}(1,data_Test.ZoneIdx(counter_TestSize))=...
                    Valid_Result{end,1}(1,data_Test.ZoneIdx(counter_TestSize))-1;
            end
end
disp('验证集处理已完成')
clear counter_hour counter_TestSize
% 我们只需要评价每个小时中红包车的ZoneIdx是否和小于0的区域一样，或者说，重叠程度
Intersect_Counter_all=0;
%每个小时重合数相加
for counter_IntSec=1:(size(Valid_Result,1)-1)
   Intersect_Counter=0;
   RedPac_Hour_Counter=0;
   Pred_RedPac=find(Valid_Result{counter_IntSec,1}<0);%1*n的向量
%    %画图专用
    Pred_Vec=sparse(zeros(1,10000));
    Pred_Vec(1,Pred_RedPac)=Pred_Vec(1,Pred_RedPac)+1;
      RedPac_Vec=sparse(zeros(1,10000));
    
   for counter_RedPac=1:size(dataStore_RedPac.Time,1)
     tmp_reg=regexp(dataStore_RedPac.Time{counter_RedPac,1},':','split');
            if  str2double(tmp_reg{1})==(counter_IntSec+5)&&dataStore_RedPac.ZoneIdx(counter_RedPac)~=0 %其实前面已经判断过了
                 Intersect_Counter= Intersect_Counter + ...
                     size(   intersect(Pred_RedPac, dataStore_RedPac.ZoneIdx(counter_RedPac))  ,2);
                 
                 RedPac_Hour_Counter=RedPac_Hour_Counter+1;
%                  %画图用
                 RedPac_Vec(1,dataStore_RedPac.ZoneIdx(counter_RedPac))=Pred_Vec(1,dataStore_RedPac.ZoneIdx(counter_RedPac))+1;
            end
   end
    Intersect_Counter_all=Intersect_Counter_all+Intersect_Counter;
    disp([num2str(counter_IntSec+5) '时预测值与红包车重叠数' num2str(Intersect_Counter) '    [*]占预测值' num2str(Intersect_Counter/size(Pred_RedPac,2))...
        '    [**]占红包车数' num2str(Intersect_Counter/ RedPac_Hour_Counter)])
    %画图
    Pred_Mat=vec2mat(Pred_Vec,100);
    Pred_Mat=Pred_Mat';
    DrawMap(Pred_Mat,['RedPac Bike Prediction' num2str(counter_IntSec+5) '时'])
    RedPac_Mat=vec2mat(RedPac_Vec,100);
    RedPac_Mat=RedPac_Mat';
    DrawMap(RedPac_Mat,['RedPac Bike Original Distribution' num2str(counter_IntSec+5) '时'])
end
for counter_IntSec=0
   Intersect_Counter=0;
   RedPac_Hour_Counter=0;
   Pred_RedPac=find(Valid_Result{end,1}<0);%1*n的向量
   for counter_RedPac=1:size(dataStore_RedPac.Time,1)
     tmp_reg=regexp(dataStore_RedPac.Time{counter_RedPac,1},':','split');
            if  str2double(tmp_reg{1})==(counter_IntSec)&&dataStore_RedPac.ZoneIdx(counter_RedPac)~=0 %其实前面已经判断过了
                 Intersect_Counter= Intersect_Counter + ...
                     size(   intersect(Pred_RedPac, dataStore_RedPac.ZoneIdx(counter_RedPac))  ,2);
                 
                 RedPac_Hour_Counter=RedPac_Hour_Counter+1;
            end
   end
    Intersect_Counter_all=Intersect_Counter_all+Intersect_Counter;
    disp([num2str(counter_IntSec) '时预测值与红包车重叠数' num2str(Intersect_Counter) '    [*]占预测值' num2str(Intersect_Counter/size(Pred_RedPac,2))...
        '    [**]占红包车数' num2str(Intersect_Counter/ RedPac_Hour_Counter)])
end
%}