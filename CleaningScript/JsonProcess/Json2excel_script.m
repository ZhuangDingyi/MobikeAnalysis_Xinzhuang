clc
dateNum_s=20171108;
dateNum_e=20171111;
for date=dateNum_s:dateNum_e
% close all
%Input folder must contain pure .json files
dateNum=num2str(date);
Input_Directory=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\DataBase_XZ\' dateNum '\json'];
Output_Directory=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\DataBase_XZ\' dateNum '\csv'];
Target_Drectory='F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\KMeansClustering\Data_XZ';
Input_Dir_stru=dir(Input_Directory);%the first two files seem useless
%% Parse the jsonfile and generate the excel
Output_table=[];
tic
for counter=3:length(Input_Dir_stru)   
% --------------���濪ʼ��Jsonת��Ϊexcel    
file_json=fileread([Input_Directory '\' Input_Dir_stru(counter).name ]);
json_par=jsondecode(file_json);

json_par_totalob=json_par.totalobjects;
Time=regexp(Input_Dir_stru(counter).name,'_','split');%�Ժ������ȫΪ_�»��� �ǵø���
Time=Time{2}(1:end-5);
% Json2excel(json_par_totalob,Output_Directory,Input_Dir_stru(counter).name(1:end-5),Time)
tmp_table=Json2excel_fullcsv(json_par_totalob,Time);
Output_table=[Output_table;tmp_table];
t1=toc;
disp([dateNum '���' num2str(counter-2) '����ʱ' num2str(t1)])
end
t=toc;
disp(['һ����ʱ' num2str(t)]);
Output_name=regexp(Input_Dir_stru(3).name,'_','split');
Output_name=Output_name{1};
writetable(Output_table,[Output_Directory '\' Output_name '.csv'])
copyfile([Output_Directory '\' Output_name '.csv'],Target_Drectory);
%ʣ�µ�ʱ���ֶ���Ҫ�Լ����
disp(['��' dateNum '���������'])
end