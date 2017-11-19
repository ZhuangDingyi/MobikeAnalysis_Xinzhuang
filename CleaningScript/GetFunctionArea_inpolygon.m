function FunctionAreaNum = GetFunctionArea_inpolygon( LongLat)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
% ���������������Ϊ [Long Lat]��ʽ��һά����
% �ú�������ѹ�����е�ͼƬ�Խ������20�������Ļ��֣����չ��ܻ���Ϊ6����
% �÷���  1.��ѹ�����е�.csv�ļ�����һ���ļ������棬��  FuncAreaDirectory �޸�Ϊ���ļ���·��
%         2.ֻ��Ҫ��������[���� ά��]����ʽ���룬�����Ϳ��Է������ڵĹ���������
% ���ޣ���Ϊ�˹����֣����ų���Щ��϶û�������ǵ�
Long=LongLat(1);
Lat=LongLat(2);
FuncAreaDirectory='F:/ScientificResearch/ChunTsung/DataSource/Crawler_Human/FunctionAreaLonglat';
% ���µ�.csv��Ϊ��Ϊ���ֵ�����γ�ȣ�������Բο�ѹ�����������ļ�
fid=fopen([FuncAreaDirectory '/Dorm.csv']);
DormArea=textscan(fid,'%.10f %.10f','Delimiter',',');
fclose(fid);
fid=fopen([FuncAreaDirectory '/Teaching.csv']);
TeachingArea=textscan(fid,'%.10f %.10f','Delimiter',',');
fclose(fid);
fid=fopen([FuncAreaDirectory '/Nature.csv']);
NatureArea=textscan(fid,'%.10f %.10f','Delimiter',',');
fclose(fid);
fid=fopen([FuncAreaDirectory '/Service.csv']);
ServiceArea=textscan(fid,'%.10f %.10f','Delimiter',',');
fclose(fid);
fid=fopen([FuncAreaDirectory '/Lab.csv']);
LabArea=textscan(fid,'%.10f %.10f','Delimiter',',');
fclose(fid);
fid=fopen([FuncAreaDirectory '/add_dorm.csv']);
addArea_dorm=textscan(fid,'%.10f %.10f','Delimiter',',');
fclose(fid);
fid=fopen([FuncAreaDirectory '/add_teaching.csv']);
addArea_teaching=textscan(fid,'%.10f %.10f','Delimiter',',');
fclose(fid);
%Cell to Matrix
DormArea=cell2mat(DormArea);
TeachingArea=cell2mat(TeachingArea);
NatureArea=cell2mat(NatureArea);
ServiceArea=cell2mat(ServiceArea);
LabArea=cell2mat(LabArea);
addArea_dorm=cell2mat(addArea_dorm);
addArea_teaching=cell2mat(addArea_teaching);
% *Area is two-dimension matrix
% using inpolygon function to detect the area
% The numbers of diffrent areas can be seen below
if inpolygon(Long,Lat,DormArea(:,2),DormArea(:,1))
    FunctionAreaNum=1;
else if inpolygon(Long,Lat,addArea_dorm(:,2),addArea_dorm(:,1))
        FunctionAreaNum=1;
    else if inpolygon(Long,Lat,TeachingArea(:,2),TeachingArea(:,1))
        FunctionAreaNum=2;
        else if inpolygon(Long,Lat,addArea_teaching(:,2),addArea_teaching(:,1))
        FunctionAreaNum=2;
    else if inpolygon(Long,Lat,ServiceArea(:,2),ServiceArea(:,1))
            FunctionAreaNum=4;
        else if inpolygon(Long,Lat,LabArea(:,2),LabArea(:,1))
                FunctionAreaNum=5;
            else if inpolygon(Long,Lat,NatureArea(:,2),NatureArea(:,1))
                    FunctionAreaNum=3;
                else if ~inpolygon(Long,Lat,[121.4315108812,121.4523949634,121.4575614616,121.4342432409],[31.0347629084,31.0413692940,31.0299077947,31.0226081242])
                        FunctionAreaNum=6;
                    else 
                        FunctionAreaNum=0;
                    end
                end
            end
        end
    end
    end
    end
end
end

