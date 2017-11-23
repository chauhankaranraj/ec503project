%% GET FILES INTO WORKSPACE

data_path = './sample_data/';

% get all files in directory
all_files = dir(data_path);

% the first three are ., .., .DS_STORE
all_files(1:3) = [];

% number of data songs
num_files = numel(all_files);

disp(['Number of h5 files found: ',num2str(num_files)]);


%% CONVERT TO DATA MATRIX

% METHODS IMPLEMENTED IN FILE READER
% 
% HDF5_Song_File_Reader           get_bars_start                  get_segments_loudness_start     
% delete                          get_beats_confidence            get_segments_pitches            
% get_analysis_sample_rate        get_beats_start                 get_segments_start              
% get_artist_7digitalid           get_danceability                get_segments_timbre             
% get_artist_familiarity          get_duration                    get_similar_artists             
% get_artist_hotttnesss           get_end_of_fade_in              get_song_hotttnesss             
% get_artist_id                   get_energy                      get_song_id                     
% get_artist_latitude             get_key                         get_start_of_fade_out           
% get_artist_location             get_key_confidence              get_tatums_confidence           
% get_artist_longitude            get_loudness                    get_tatums_start                
% get_artist_mbid                 get_mode                        get_tempo                       
% get_artist_mbtags               get_mode_confidence             get_time_signature              
% get_artist_mbtags_count         get_num_songs                   get_time_signature_confidence   
% get_artist_name                 get_release                     get_title                       
% get_artist_playmeid             get_release_7digitalid          get_track_7digitalid            
% get_artist_terms                get_sections_confidence         get_track_id                    
% get_artist_terms_freq           get_sections_start              get_year                        
% get_artist_terms_weight         get_segments_confidence         
% get_audio_md5                   get_segments_loudness_max       
% get_bars_confidence             get_segments_loudness_max_time  

num_features = 57;
all_data = zeros(num_files, num_features);

dummy_file = HDF5_Song_File_Reader(strcat(data_path, all_files(1).name));

fields = fieldnames(dummy_file.analysis);
num_analysis_fields = 0;

f_idx = 1;
while f_idx ~= numel(fields)

    if ~ischar(dummy_file.analysis.(fields{f_idx}))
        num_analysis_fields = num_analysis_fields + 1;
        f_idx = f_idx + 1;
    else
        fields(f_idx) = [];
    end
    
end

% num_analysis_fields = numel(fieldnames(dummy_file.analysis));

% analysis_vals = zeros(num_files, num_analysis_fields);
% 
% for file_idx = 1:num_files
%     
%     song = HDF5_Song_File_Reader(strcat(data_path, all_files(file_idx).name));
%     analysis_vals(file_idx, :) = song.attr
%     disp(song);
%     
% end
% 
% disp('done');
% 
% 
% c = categorical({'Male','Female','Female','Male','Female'})
% n = grp2idx(c)



