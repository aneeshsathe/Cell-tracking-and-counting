% function an_pas_count_obj()
clear
clc

root_root='Y:\Pascale Cell tracking\';
file_ext='tif';

[Outfiles, outDir]= an_recdir( root_root,file_ext);

for fold_count=1%:numel(Outfiles)
[~,in_file_name,~]=fileparts(Outfiles{fold_count});
img_write_path=fullfile(outDir{fold_count}, ['results_', date],filesep);
mkdir(img_write_path);
file_path=Outfiles{fold_count};

%%

% file_path='Y:\Pascale Cell tracking\2014-01-02-C6-LN-With-serum-2-dapi.tif';
% img_write_path='Y:\Pascale Cell tracking\';
[gray_img, raw_img] = read_stack( file_path );

%%
% out_P1=double(zeros(size(gray_img)));
num_obj{1,1}='Nuc Num';
parfor count=1:size(gray_img,3)
    [num_obj{count+1,1},out_img(:,:,count)]=an_pas_obj(gray_img(:,:,count));
    
end
%%
for count2=1:size(out_img,3)
    if count2==1
        imwrite(insertText(out_img(:,:,count2),[1,1],['No. of objects:',num2str(num_obj{count2+1})],'FontSize',71),...
            [img_write_path,'out_img_',in_file_name,'.tif'], 'Compression','deflate')
    else
      
        imwrite(insertText(out_img(:,:,count2),[1,1],['No. of objects:',num2str(num_obj{count2+1})],'FontSize',71),...
            [img_write_path,'out_img_',in_file_name,'.tif'],'Compression','deflate','WriteMode','append')
    end
end
%%

%% write data

xls_file_name= fullfile(outDir{fold_count}, ['results_', date],'out_results.txt');

dlmcell(xls_file_name,num_obj,',')

%write excel file if OS is windows
if ispc
    xls_file_name2=fullfile(outDir{fold_count}, ['results_', date],'out_results.xls');
    xlswrite(xls_file_name2,num_obj,'Sheet1' );
    xlswrite(xls_file_name2,num_obj,'Sheet2' );
end


disp('done writing excel file')
end
 
