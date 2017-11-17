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

files = dir('./sample_data/*.txt');
for i=1:length(files)
    eval(['load ' files(i).name ' -ascii']);
end