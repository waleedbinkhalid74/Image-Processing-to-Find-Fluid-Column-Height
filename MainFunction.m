clear;
% arduinoObject = arduino('COM6');
teamName = 'Test7March';
mkdir Test7March;
destDirectory = strcat('C:\Users\Dell\Dropbox\pipeflow\PipeFlow Code\PipeFlow Code\', teamName); 
% % 
% pinMode(arduinoObject, 6, 'output');
% servoAttach(arduinoObject, 6);

% url = 'http://192.168.43.1:8080/shot.jpg';
% snap = imread(url);
% imshow(snap);
% fullDestination = fullfile(destDirectory, 'snap1.jpg');
% imwrite(snap, fullDestination);

% for i = 1:18
% 
%     servoWrite(arduinoObject, 6, 180);
%     pause(0.05);
%     servoWrite(arduinoObject, 6, 90);
%     pause(3)
% %     servoDetach(arduinoObject, 6);
%     
%     snap = imread(url);
%     fileName = strcat('snap', int2str(i+1), '.jpg');
%     fullDestination = fullfile(destDirectory, fileName);
%     imwrite(snap, fullDestination);
% end
% %    
% % 
allLetters = '';
allLengths = [];
% 
for j = 1:19
    snapName = strcat('snap', int2str(j), '.jpg');
    imForProcessing = imread(fullfile(destDirectory, snapName));
    imForProcessing = imresize(imForProcessing, 0.25);
    redbox = RedBoxDetector(imForProcessing);
    [letters, lengthOfCol] = Cropper(imForProcessing);
    allLetters=[allLetters, letters];
    allLengths = [allLengths ,lengthOfCol];
    disp(allLetters);
    disp(allLengths);
%     pause;
end

sortedLetters = '';
sortedLengths = [];

for w = 1:length(allLetters)
    if ismember(allLetters(w), sortedLetters)
        continue
    else
        total = 0;
        count = 0;
        for y = w:length(allLetters)
            if allLetters(y) == allLetters(w);
                total = total + allLengths(y);
                count = count + 1;
            else
                continue
            end
        end
        sortedLengths = [sortedLengths, total/count];
        sortedLetters = [sortedLetters, allLetters(w)];
    end
end
%        
% letterCol = strcat('A1:A', num2str(length(sortedLetters)));
% lengthCol = strcat('B1:B', num2str(length(sortedLengths)));
% xlswrite(strcat(destDirectory,'\Results.xlsx'), sortedLetters', letterCol);
% xlswrite(strcat(destDirectory,'\Results.xlsx'), sortedLengths', lengthCol);
% % 
