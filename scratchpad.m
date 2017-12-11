% level = 5;
% semester = 'Fall';
% subject = 'Math';
% student = 'John_Doe';
% fieldnames = {semester subject student};
% 
% % Add data to a structure named grades.
% grades(level).(semester).(subject).(student)(10,21:30) = ...
%              [85, 89, 76, 93, 85, 91, 68, 84, 95, 73];
% 
% % Retrieve the data added.
% getfield(grades, {level}, fieldnames{:}, {10,21:30})

y = zeros(18,1);

y(1) = 10;
% y(2) = 2;
% y(3) = 1.5;
% y(4) = 1.25;
% y(5) = 1;
% y(6) = 0.5;
% y(7) = 0.4;
% y(8) = 0.5;
% y(9) = 1;
% y(10) = 2;
% y(11) = 1.75;
% y(12) = 1.5;
% y(13) = 1.5;
% y(14) = 1.25;
% y(15) = 1.75;
% y(16) = 4;
% y(17) = 2;
% y(18) = 2;

stem(1:18, y, 'filled');
xlabel 'Point'
ylabel 'Reachability Distance'
title 'Reachability Plot'


