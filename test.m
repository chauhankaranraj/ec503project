% % testing out reader
% song = HDF5_Song_File_Reader('./sample_data/TRAAAAW128F429D538.h5');
% 
% % song attribuets
% danceability = song.get_danceability()
% duration = song.get_duration()
% energy = song.get_energy()
% hotness = song.get_song_hotttnesss()
% title = song.get_title()
% 
% % what methods have they implemented??
% methods('HDF5_Song_File_Reader')
% 
% files = dir('./sample_data/*.txt');
% for i=1:length(files)
%     eval(['load ' files(i).name ' -ascii']);
% end

% load fisheriris
% 
% X = meas(:,3:4);
% y = grp2idx(categorical(species));

load('gen_data.mat');
X = transpose(data);

epsilon = 2;
min_points = 5;

[assignments, li_noise] = DBSCAN(X, epsilon, min_points);

figure;
for c_num = 0:max(assignments)
    scatter3(X(assignments==c_num,1), X(assignments==c_num,2), X(assignments==c_num,3));
    hold on
end

