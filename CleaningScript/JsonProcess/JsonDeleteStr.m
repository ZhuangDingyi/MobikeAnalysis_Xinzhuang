
clc
close all
dateNum_s=20170706;
dateNum_e
tic
    Input_Directory='F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\DataBase\20170706\json';
    Input_Dir_stru=dir(Input_Directory);

    for counter=3:length(Input_Dir_stru)
    i=0;
    flag=0;
    fid=fopen([Input_Directory '\' Input_Dir_stru(counter).name ],'r+');
    while ~feof(fid)
    tline=fgetl(fid);
    i=i+1;
    tmp{i}=tline;
    if flag
        tmp{i}=[tmp{i-2},tmp{i}];
        tmp{i-2}='';
        flag=0;
    end
    if length(tline)<6&&length(tline)>=1
        tmp{i}='';
        flag=1;
    end
    if tmp{i}=='0'
        tmp{i}='';
    end
    end
    fclose(fid);
    fid=fopen([Input_Directory '\' Input_Dir_stru(counter).name ],'w+');
        for j=1:i-1
        fprintf(fid,'%s\n',tmp{j});
        end
    fclose(fid);
    disp(['第' num2str(counter-2) 'Json反爬虫数据流处理完成'])
    end 
end
toc 

