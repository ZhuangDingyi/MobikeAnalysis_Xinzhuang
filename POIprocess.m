clc
% ��һ�ݽű�ϣ���о���ͬPOI�������еķֲ����
% ��Ҫ���õ���POI��csv�����������csv
% �ȼ�����������
%% ȫ�ֱ�������
dtNum='20170930_20171111_XZ';
dir_lv='F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\LouvainOutput';
Dir_poi='F:\ScientificResearch\ChunTsung\DataSource\POI_crawler\POI_csv';
poi_tags={'gov','health','house','transport'};
Output_image='F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\Output_image_POI';
%�����������������˴�ֻ����80Ϊ�������Ը��Ĵ���
width=80;
height=80;
GridsNum=width*height;
zone_long=linspace(121.3647425445,121.4353779391,(width+1));%��101������100��
zone_lat=linspace(31.0939138469,31.1522631725,(height+1));
% --------------------------------
%% ���ݵ���
% POI���ݵ���
for poi_tag_counter=1:length(poi_tags)
    poi_tag=poi_tags{poi_tag_counter};
    Dir_poi_2read=[Dir_poi '\' poi_tag 'POI.csv'];
    poi_format_2read='%s%s%.6f%.6f';
    eval([ poi_tag 'POI=readtable(''' Dir_poi_2read  ''',''ReadVariableNames'',false,''Format'',''' poi_format_2read ''');' ])
    %��POI���ݼ���ZoneIdx
    eval([ 'poi_long=',poi_tag,'POI.Var4;' ])
    eval([ 'poi_lat=',poi_tag,'POI.Var3;' ])
        poi_long_idx=zeros(length(poi_long),1);
        poi_lat_idx=zeros(length(poi_lat),1);
        poi_zone_idx=zeros(length(poi_lat),1);
            for counter=1:length(poi_long_idx)
                tmp_lng=find(zone_long>=poi_long(counter));%ֻ�е�һ����������Ҫ��,������Ƚ��٣������������
                tmp_lat=find(zone_lat>=poi_lat(counter));
                    if ~isempty(tmp_lng)&&~isempty(tmp_lat)
                        poi_long_idx(counter)=tmp_lng(1)-1;%��ӳ����������������������Ļ��ֵ�
                        poi_lat_idx(counter)=tmp_lat(1)-1;
                    end
            end
        clear tmp_lat tmp_lng counter
        tmp_zone_idx=find(poi_long_idx>0&poi_lat_idx>0);
        poi_zone_idx(tmp_zone_idx)=(poi_long_idx(tmp_zone_idx)-1)*height+height+1-poi_lat_idx(tmp_zone_idx);%0��ʾ���ڻ��ֵ������д��������������µ��� ������������ʽ������������һ��
        clear tmp_zone_idx
    eval([poi_tag 'POI.ZoneIdx=poi_zone_idx;'])%������������ӵ�����
end
clear Dir_poi_2read poi_format_2read poi_tag poi_tag_counter
% Var1 is the name and Var is the address
% �������ݵ���
for lv_read_counter=30:10:100 % �������һ����30:10:100
    File_lv_2read=[dir_lv,'\',dtNum,'\','LouvainOutput_',dtNum,'_',num2str(lv_read_counter),'_',num2str(lv_read_counter),'.csv'];
    eval(['lv_',num2str(lv_read_counter),'_',num2str(lv_read_counter),'=readtable(''',File_lv_2read ,''');'])
end
clear lv_read_counter Dir_lv_2read
%% POIȥ�㴦��
for poi_tag_counter=1:length(poi_tags)
    poi_tag=poi_tags{poi_tag_counter};
    eval(['tmp_POI_iszero=' poi_tag 'POI.ZoneIdx==0;'])
    eval([poi_tag 'POI(tmp_POI_iszero,:)=[];'])
end
%% ��������
x=lv_80_80.ZoneIdx(lv_80_80.Community==259);
lv_vec=sparse(zeros(GridsNum,1));
lv_vec(x)=1;
lv_mat=vec2mat(lv_vec,width);
lv_mat=lv_mat';
DrawMap_XZ(lv_mat,[num2str(width) '*' num2str(height) ' LouvainCmtDistribution No.' num2str(259)],width,height);
%% ��������POI�ķֲ�ͼ
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
%% POI��������
%���о���ͨȻ��ѭ������һ��
for poi_tag_counter=1:length(poi_tags)
poi_tag=poi_tags{poi_tag_counter};
eval( ['tmp_end=size(' ,poi_tag, 'POI,1);'] )
eval( ['poi_cmt=cell(size(' ,poi_tag, 'POI,1)); '] )

   for zoneidx_counter=1:tmp_end
        %�����Ҫ�ı�width��height�˴����eval
   eval( ['    tmp_zoneidx=', poi_tag ,'POI.ZoneIdx(zoneidx_counter);'])
        poi_cmt{zoneidx_counter,1}= unique(lv_80_80.Community(lv_80_80.ZoneIdx==tmp_zoneidx));
    end
    clear tmp_zoneidx zoneidx_counter
    %�Ѿ�����poi���ÿ��POI��Ӧ������
    idx_poi_not0=cellfun(@isempty,poi_cmt);
    idx_poi_not0=~idx_poi_not0;
    %���ɱ�Ҫ������
   eval([' poi_name_',poi_tag,'=', poi_tag ,'POI.Var1(idx_poi_not0);'])
   eval([' poi_zoneidx_',poi_tag,'=',poi_tag,'POI.ZoneIdx(idx_poi_not0);'])
    poi_cmt=poi_cmt(idx_poi_not0);
    %��ʼ��ͼ

    if ~exist([Output_image '\' poi_tag '_' num2str(width) '_' num2str(height)])
        mkdir([Output_image '\' poi_tag '_' num2str(width) '_' num2str(height)])
    end

    POIcmt_video=VideoWriter([Output_image '\' poi_tag '_' num2str(width) '_' num2str(height) '_' poi_tag ' POI_cmt.avi' ]);
    POIcmt_video.FrameRate=2;
    open(POIcmt_video)
    h=waitbar(0,['Processing ',poi_tag,'POI Zoneidx and their Communities']);
    for poi_cmt_counter=1:length(poi_cmt)
        tmp_cmts=poi_cmt{poi_cmt_counter};%tmp_cmt ����ڶ������ֵ�����
        for tmp_cmts_counter=1:length(tmp_cmts)%���⿪ʼ��ÿ��cmt���л�ͼ
            tmp_cmt=tmp_cmts(tmp_cmts_counter);
            tmp_lv_poi_vec=sparse(zeros(GridsNum,1));
            tmp_lv_poi_vec_idx=lv_80_80.ZoneIdx(lv_80_80.Community==tmp_cmt);
            tmp_lv_poi_vec(tmp_lv_poi_vec_idx)=tmp_lv_poi_vec(tmp_lv_poi_vec_idx)+1;
          eval(['  tmp_lv_poi_vec(poi_zoneidx_',poi_tag,'(poi_cmt_counter))=tmp_lv_poi_vec(poi_zoneidx_',poi_tag,'(poi_cmt_counter))+3;'])%��ѡ������͹�Գ���
            tmp_lv_poi_mat=vec2mat(tmp_lv_poi_vec,height);
            tmp_lv_poi_mat=tmp_lv_poi_mat';
          eval(['  tmp_name=poi_name_',poi_tag,'{poi_cmt_counter};'])
            [frame,handler]=DrawMap_XZ(tmp_lv_poi_mat,[poi_tag 'POI ' tmp_name,' ', num2str(width) '*' num2str(height)  ' cmtNo ' num2str(tmp_cmt)],width,height);
            writeVideo(POIcmt_video,frame)
            print( [Output_image '\' poi_tag '_' num2str(width) '_' num2str(height) '\' poi_tag 'POI_cmtNo_' num2str(tmp_cmt)],'-dpng'  )%���ɶ�Ӧ����
            print( [Output_image '\' poi_tag '_' num2str(width) '_' num2str(height) '\' poi_tag 'POI_' tmp_name 'cmtNo_' num2str(tmp_cmt)],'-dpng'  )%��һ��Ӧ����LV_Output_cmt_uniq(ii)�ɣ���Ӧ����
            close(handler)
        end
        waitbar(poi_cmt_counter/length(poi_cmt))
    end
    close(h)
    close(POIcmt_video)
disp([poi_tag '�����е�POIλ��ͼ���'])
end
close(POIcmt_video)
close all %�ص�����figure
clear tmp* h frame