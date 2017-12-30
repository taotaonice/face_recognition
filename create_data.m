% create_data.m

clear;close all;clc

dataset_path = './dataset/';

face_classes = dir(dataset_path);
pick = arrayfun(@(x) (strcmpi(x.name,'.')|strcmpi(x.name,'..')), face_classes);
face_classes(pick) = [];

n_people = length(face_classes);
dataset(n_people).label = n_people;
dataset(n_people).name = '';
dataset(n_people).path = '';

for ii = 1:n_people
    fprintf('%d / %d\n',ii,n_people);
    dataset(ii).label = ii;
    dataset(ii).name = face_classes(ii).name;
    dataset(ii).path = fullfile(face_classes(ii).folder, face_classes(ii).name);
    flist = dir(dataset(ii).path);
    pick = arrayfun(@(x) (strcmpi(x.name,'.')|strcmpi(x.name,'..')), flist);
    flist(pick) = [];
    dataset(ii).num = length(flist);
    dataset(ii).pic(length(flist)).path = '';
    for jj = 1:length(flist)
        dataset(ii).pic(jj).path = fullfile(flist(jj).folder,flist(jj).name);
    end
end

save('facedata.mat','dataset')