clc
% 这一份脚本希望研究不同POI在社区中的分布情况
% 需要引用的是POI的csv和社区输出的csv
% 先检查社区的输出
%% 全局变量定义
dtNum='20170930_20171111_XZ';
dir_lv='F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\LouvainOutput';
Dir_poi='F:\ScientificResearch\ChunTsung\DataSource\POI_crawler\POI_csv';
poi_tags={'gov','health','house','transport'};
Output_image='F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\Output_image_POI';
%————————此处只是以80为例，可以更改此项
width=80;
height=80;
GridsNum=width*height;
zone_long=linspace(121.3647425445,121.4353779391,(width+1));%是101而不是100！
zone_lat=linspace(31.0939138469,31.1522631725,(height+1));
% --------------------------------
%% 数据导入
% POI数据导入
for poi_tag_counter=1:length(poi_tags)
    poi_tag=poi_tags{poi_tag_counter};
    Dir_poi_2read=[Dir_poi '\' poi_tag 'POI.csv'];
    poi_format_2read='%s%s%.6f%.6f';
    eval([ poi_tag 'POI=readtable(''' Dir_poi_2read  ''',''ReadVariableNames'',false,''Format'',''' poi_format_2read ''');' ])
    %给POI数据加入ZoneIdx
    eval([ 'poi_long=',poi_tag,'POI.Var4;' ])
    eval([ 'poi_lat=',poi_tag,'POI.Var3;' ])
        poi_long_idx=zeros(length(poi_long),1);
        poi_lat_idx=zeros(length(poi_lat),1);
        poi_zone_idx=zeros(length(poi_lat),1);
            for counter=1:length(poi_long_idx)
                tmp_lng=find(zone_long>=poi_long(counter));%只有第一项是我们需要的,等于项比较少？归入大于项中
                tmp_lat=find(zone_lat>=poi_lat(counter));
                    if ~isempty(tmp_lng)&&~isempty(tmp_lat)
                        poi_long_idx(counter)=tmp_lng(1)-1;%反映的是所属区间而不是所属的划分点
                        poi_lat_idx(counter)=tmp_lat(1)-1;
                    end
            end
        clear tmp_lat tmp_lng counter
        tmp_zone_idx=find(poi_long_idx>0&poi_lat_idx>0);
        poi_zone_idx(tmp_zone_idx)=(poi_long_idx(tmp_zone_idx)-1)*height+height+1-poi_lat_idx(tmp_zone_idx);%0表示不在划分的区域中从左上序数往右下递增 ↓↓↓这种形式，矩阵列向量一样
        clear tmp_zone_idx
    eval([poi_tag 'POI.ZoneIdx=poi_zone_idx;'])%将所属区域添加到表中
end
clear Dir_poi_2read poi_format_2read poi_tag poi_tag_counter
% Var1 is the name and Var is the address
% 社区数据导入
for lv_read_counter=30:10:100 % 社区输出一般是30:10:100
    File_lv_2read=[dir_lv,'\',dtNum,'\','LouvainOutput_',dtNum,'_',num2str(lv_read_counter),'_',num2str(lv_read_counter),'.csv'];
    eval(['lv_',num2str(lv_read_counter),'_',num2str(lv_read_counter),'=readtable(''',File_lv_2read ,''');'])
end
clear lv_read_counter Dir_lv_2read
%% POI去零处理
for poi_tag_counter=1:length(poi_tags)
    poi_tag=poi_tags{poi_tag_counter};
    eval(['tmp_POI_iszero=' poi_tag 'POI.ZoneIdx==0;'])
    eval([poi_tag 'POI(tmp_POI_iszero,:)=[];'])
end
%% 社区检验
x=lv_80_80.ZoneIdx(lv_80_80.Community==259);
lv_vec=sparse(zeros(GridsNum,1));
lv_vec(x)=1;
lv_mat=vec2mat(lv_vec,width);
lv_mat=lv_mat';
DrawMap_XZ(lv_mat,[num2str(width) '*' num2str(height) ' LouvainCmtDistribution No.' num2str(259)],width,height);
%% 生成所有POI的分布图
for poi_tag_counter=1:length(poi_tags)
    poi_tag=poi_tags{poi_tag_counter};
    eval(['tmp_zoneidx_all=' poi_tag 'POI.ZoneIdx;'])
    tmp_poi_vec=sparse(zeros(GridsNum,1));
    tmp_poi_vec(tmp_zoneidx_all)=1;
    tmp_poi_mat=vec2mat(tmp_poi_vec,height);
    tmp_poi_mat=tmp_poi_mat';
    DrawMap_XZ(tmp_poi_mat,[poi_tag 'POI ' ,' ', num2str(width) '*' num2str(height)  ' CommunityDistribution '],width,height);
    print( [Output_image '\' poi_tag '_' num2str(width) '_' num2str(height) '\' poi_tag 'POI_CommunityDistribution'],'-dpng'  )
end
clear tmp*
%% POI社区所属
%先研究交通然后循环迭代一下
for poi_tag_counter=1:length(poi_tags)
poi_tag=poi_tags{poi_tag_counter};
eval( ['tmp_end=size(' ,poi_tag, 'POI,1);'] )
eval( ['poi_cmt=cell(size(' ,poi_tag, 'POI,1)); '] )

   for zoneidx_counter=1:tmp_end
        %如果需要改变width和height此处变成eval
   eval( ['    tmp_zoneidx=', poi_tag ,'POI.ZoneIdx(zoneidx_counter);'])
        poi_cmt{zoneidx_counter,1}= unique(lv_80_80.Community(lv_80_80.ZoneIdx==tmp_zoneidx));
    end
    clear tmp_zoneidx zoneidx_counter
    %已经生成poi表格每个POI对应的社区
    idx_poi_not0=cellfun(@isempty,poi_cmt);
    idx_poi_not0=~idx_poi_not0;
    %生成必要的数据
   eval([' poi_name_',poi_tag,'=', poi_tag ,'POI.Var1(idx_poi_not0);'])
   eval([' poi_zoneidx_',poi_tag,'=',poi_tag,'POI.ZoneIdx(idx_poi_not0);'])
    poi_cmt=poi_cmt(idx_poi_not0);
    %开始画图

    if ~exist([Output_image '\' poi_tag '_' num2str(width) '_' num2str(height)])
        mkdir([Output_image '\' poi_tag '_' num2str(width) '_' num2str(height)])
    end

    POIcmt_video=VideoWriter([Output_image '\' poi_tag '_' num2str(width) '_' num2str(height) '_' poi_tag ' POI_cmt.avi' ]);
    POIcmt_video.FrameRate=2;
    open(POIcmt_video)
    h=waitbar(0,['Processing ',poi_tag,'POI Zoneidx and their Communities']);
    for poi_cmt_counter=1:length(poi_cmt)
        tmp_cmts=poi_cmt{poi_cmt_counter};%tmp_cmt 会存在多个社区值的情况
        for tmp_cmts_counter=1:length(tmp_cmts)%从这开始对每个cmt进行画图
            tmp_cmt=tmp_cmts(tmp_cmts_counter);
            tmp_lv_poi_vec=sparse(zeros(GridsNum,1));
            tmp_lv_poi_vec_idx=lv_80_80.ZoneIdx(lv_80_80.Community==tmp_cmt);
            tmp_lv_poi_vec(tmp_lv_poi_vec_idx)=tmp_lv_poi_vec(tmp_lv_poi_vec_idx)+1;
          eval(['  tmp_lv_poi_vec(poi_zoneidx_',poi_tag,'(poi_cmt_counter))=tmp_lv_poi_vec(poi_zoneidx_',poi_tag,'(poi_cmt_counter))+3;'])%将选中区域凸显出来
            tmp_lv_poi_mat=vec2mat(tmp_lv_poi_vec,height);
            tmp_lv_poi_mat=tmp_lv_poi_mat';
          eval(['  tmp_name=poi_name_',poi_tag,'{poi_cmt_counter};'])
            [frame,handler]=DrawMap_XZ(tmp_lv_poi_mat,[poi_tag 'POI ' tmp_name,' ', num2str(width) '*' num2str(height)  ' cmtNo ' num2str(tmp_cmt)],width,height);
            writeVideo(POIcmt_video,frame)
            print( [Output_image '\' poi_tag '_' num2str(width) '_' num2str(height) '\' poi_tag 'POI_cmtNo_' num2str(tmp_cmt)],'-dpng'  )%生成对应社区
            print( [Output_image '\' poi_tag '_' num2str(width) '_' num2str(height) '\' poi_tag 'POI_' tmp_name 'cmtNo_' num2str(tmp_cmt)],'-dpng'  )%这一步应该是LV_Output_cmt_uniq(ii)吧？对应起来
            close(handler)
        end
        waitbar(poi_cmt_counter/length(poi_cmt))
    end
    close(h)
    close(POIcmt_video)
disp([poi_tag '的所有的POI位置图完成'])
end
close(POIcmt_video)
close all %关掉所有figure
clear tmp* h frame