clc
close all
dateNum_s=20171105;
dateNum_e=20171111;
%% ����������
tic
disp('��ʼ������Ϊjson����')
for ii=dateNum_s:dateNum_e
    Input_Directory=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\DataBase_XZ\' num2str(ii) '\json'];
    Input_Dir_stru=dir(Input_Directory);
    for counter=3:length(Input_Dir_stru)
        OldName=[Input_Directory '\' Input_Dir_stru(counter).name];
        NewName=[OldName '.json'];
        movefile(OldName,NewName)
    end
    disp([ num2str(ii) '��������Ϊjson�������'])

end
toc 
%% �����ϲ��ļ�
tic
disp('��ʼ�����ϲ��ļ�')
for ii=dateNum_s:dateNum_e
    Input_Directory=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\DataBase_XZ\' num2str(ii) '\json'];
    Input_Dir_stru=dir(Input_Directory);
    Name_Stru=cell(size(Input_Dir_stru,1)-2,1);
    Name_Stru_split=cell(size(Name_Stru));
    for counter=3:length(Input_Dir_stru)
        Name_Stru{counter-2,1}=Input_Dir_stru(counter).name;
        Name_Stru_split{counter-2,1}=regexp(Name_Stru{counter-2,1},'_','split');
    end
    
    for i=1:length(Name_Stru_split)
        if length(Name_Stru_split{i,1}) >2
            file2write=fopen( [Input_Directory '\' Name_Stru_split{i,1}{1,1} '_' Name_Stru_split{i,1}{1,2} '.json'   ],'a');
            file2read =fopen([Input_Directory '\' Name_Stru_split{i,1}{1,1} '_' Name_Stru_split{i,1}{1,2} '_' Name_Stru_split{i,1}{1,3}   ],'r');
            txt=fread(file2read,inf);
            fclose(file2read);
            fwrite(file2write,txt);
            delete([Input_Directory '\' Name_Stru_split{i,1}{1,1} '_' Name_Stru_split{i,1}{1,2} '_' Name_Stru_split{i,1}{1,3}   ])
            fclose(file2write);
        end        
    end
    
    
    disp([ num2str(ii) '�������ϲ��ļ����'])

end
toc 

%% ����������������
tic
disp('��ʼ����������������')
for ii=dateNum_s:dateNum_e
    Input_Directory=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\DataBase_XZ\' num2str(ii) '\json'];
%     disp([num2str(ii) '������������'])
%     copyfile('F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\MATLAB_Data_Cleaning\Script\JsonProcess\Rename_Add.bat',Input_Directory)
%     system([Input_Directory '\Rename_Add.bat'])
%     delete([Input_Directory '\Rename_Add.bat'])
%     disp(['   ' num2str(ii) '�������������ɹ�'])
    %��������ϴ
    Input_Dir_stru=dir(Input_Directory);
    for counter=3:length(Input_Dir_stru)
    i=0;
    tmp={};
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
    end 
    disp([ num2str(ii) '�������Json�������������������'])
%     disp(['��ʼ����' num2str(ii) '���AutoIT��������Լ���β���'])
%     copyfile('F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\MATLAB_Data_Cleaning\Script\JsonProcess\Cleaning.au3',Input_Directory)
%     copyfile('F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\MATLAB_Data_Cleaning\Script\JsonProcess\shouwei_new.bat',Input_Directory)
%     system([Input_Directory '\Cleaning.au3'])
%     system([Input_Directory '\shouwei_new.bat'])
%     delete([Input_Directory '\Cleaning.au3'])
%     delete([Input_Directory '\shouwei_new.bat'])
%     disp(['   ' num2str(ii) '��������ϴ��һ���ɹ�����˶��ļ�����õڶ�����'])
end
toc 
%% ����ɾ��
disp('��ʼ����ɾ��')
tic
for ii=dateNum_s:dateNum_e
    Input_Directory=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\DataBase_XZ\' num2str(ii) '\json'];
    Input_Dir_stru=dir(Input_Directory);
    for counter=3:length(Input_Dir_stru)
    i=0;
    tmp_reg={};
    fid=fopen([Input_Directory '\' Input_Dir_stru(counter).name ],'r+');
    while ~feof(fid)
    tline=fgetl(fid);
    i=i+1;
    tmp_reg{i}=tline;
    condition_sapce=~isempty(strfind(tmp_reg{i},'HTTP' ))||...
        ~isempty(strfind(tmp_reg{i},'Connection:' ))||...
        ~isempty(strfind(tmp_reg{i},'Date:' ))||...
        ~isempty(strfind(tmp_reg{i},'Content-Length:' ))||...
        ~isempty(strfind(tmp_reg{i},'Connection:' ))||...
        ~isempty(strfind(tmp_reg{i},'Server:' ))||...
        ~isempty(strfind(tmp_reg{i},'X-Application-Context:' ))||...
        ~isempty(strfind(tmp_reg{i},'Host:' ))||...
        ~isempty(strfind(tmp_reg{i},'Accept-Encoding:' ))||...
        ~isempty(strfind(tmp_reg{i},'platform:' ))||...
        ~isempty(strfind(tmp_reg{i},'mobileNo:' ))||...
        ~isempty(strfind(tmp_reg{i},'eption:' ))||...
        ~isempty(strfind(tmp_reg{i},'time:' ))||...
        ~isempty(strfind(tmp_reg{i},'lang:' ))||...
        ~isempty(strfind(tmp_reg{i},'uuid:' ))||...
        ~isempty(strfind(tmp_reg{i},'version:' ))||...
        ~isempty(strfind(tmp_reg{i},'citycode:' ))||...
        ~isempty(strfind(tmp_reg{i},'accesstoken:' ))||...
        ~isempty(strfind(tmp_reg{i},'os:' ))||...
        ~isempty(strfind(tmp_reg{i},'version' ))||...
        ~isempty(strfind(tmp_reg{i},'userid' ))||...
        ~isempty(strfind(tmp_reg{i},'citycode:' ))||...
        ~isempty(strfind(tmp_reg{i},'Transfer-Encoding:' ));
    condition_comma=~isempty(strfind(tmp_reg{i},'Content-Type:' ));
        if condition_sapce
            tmp_reg{i}=' ';
        else if condition_comma
                tmp_reg{i}=',';
            end
        end
    
        
    end
    fclose(fid);
    fid=fopen([Input_Directory '\' Input_Dir_stru(counter).name ],'w+');
        for j=1:i-1
        fprintf(fid,'%s\n', tmp_reg{j});
        end
    fclose(fid);
    end 
    
    disp([ num2str(ii) '����������򻯴������'])

end
toc 
%% ���ж���ɾ���Լ���β�� ���
disp('��ʼ�滻��β���')
tic
for ii=dateNum_s:dateNum_e
    
    Input_Directory=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\DataBase_XZ\' num2str(ii) '\json'];
    Input_Dir_stru=dir(Input_Directory);
    for counter=3:length(Input_Dir_stru)
    i=0;
    tmp_rep={};
    fid=fopen([Input_Directory '\' Input_Dir_stru(counter).name ],'r+');
        while ~feof(fid)
        tline=fgetl(fid);
        i=i+1;
        tmp_rep{i}=tline;       
        end
    
    for i =1:size(tmp_rep,2)
        if tmp_rep{i}==','
            tmp_rep{i}='{ "totalobjects":[';
            break
        end
    end
    
    for i=size(tmp_rep,2):-1:1
         if tmp_rep{i}==','
            tmp_rep{i}=']}';
            break
        end
    end
%     tmp_rep{size(tmp_rep,2)+1}=']}';
    
    fclose(fid);
    fid=fopen([Input_Directory '\' Input_Dir_stru(counter).name ],'w+');
        for j=1:size(tmp_rep,2)
        fprintf(fid,'%s\n', tmp_rep{j});
        end
    fclose(fid);
    end 
    
    disp([ num2str(ii) '�����β���滻�������'])

end
toc 
%% ����Ƿ�������ڵĶ���
% ��ɾȥ����
tic
disp('��ʼɾ������')
for ii=dateNum_s:dateNum_e
    Input_Directory=['F:\ScientificResearch\ChunTsung\DataSource\Crawler_Human\DataBase_XZ\' num2str(ii) '\json'];
    Input_Dir_stru=dir(Input_Directory);

    for counter=3:length(Input_Dir_stru)
    i=0;
    tmp={};
    fid=fopen([Input_Directory '\' Input_Dir_stru(counter).name ],'r+');
        while ~feof(fid)
            tline=fgetl(fid);
            i=i+1;
            tmp{i}=tline;           
        end
         fclose(fid);
%         ɾ������
        tmp(cellfun(@isempty,tmp))=[]; %�˴���ɾ������Ŀ��������ɾ��һ���ո���Ŀ
        tmp(cellfun(@(x) isequal(x,' '),tmp))=[];        
        coma=1;
        if tmp{2}==','
            tmp{2}=[];
        end
        while coma<length(tmp)                
            if tmp{coma}==','&tmp{coma+1}==','
                tmp{coma}=[];
            end
            coma=coma+1;
        end
        fid=fopen([Input_Directory '\' Input_Dir_stru(counter).name ],'w+');
        for j=1:size(tmp,2)
        fprintf(fid,'%s\n', tmp{j});
        end
        fclose(fid);
    end
        disp([ num2str(ii) '������ڶ����Ѿ�ɾ�����'])
end
toc 