BasePath = '...\HMC_ComVeh_SCC_';
DirList = dir(BasePath);
DirList = DirList([DirList.isdir]);

for iDir = 3:numel(DirList)
    aDir = fullfile(BasePath, DirList(iDir).name);
    fprintf('Processing: %s\n', aDir);
    cd(aDir)

    open('...\Test_Battery_Ign_off.slx')
    sim('...\Test_Battery_Ign_off.slx')
    close_system('...\Test_Battery_Ign_off.slx')
    
    open('...\Test_Battery_Ign_on.slx')
    sim('...\Test_Battery_Ign_on.slx')
    close_system('...\Test_Battery_Ign_on.slx')
           
    %% Set-up of variables
    Run(1).Settings ={};    
    ExeName = 'PreScan.CLI.exe';
    disp('Setting-up variables...');
    disp('------------------------');
    ExperimentName = 'SCC_CUTIN_01';
    MainExperiment = pwd;
    ExperimentDir = [pwd '\..'];
    ResultsDir = [MainExperiment '\Results\TA_' sprintf('%04.0f%02.0f%02.0f_%02.0f%02.0f%02.0f',clock)];
    
    % Number of simulations.
    NrOfRuns = length(Run);
    
   %% The simulations
    Results(NrOfRuns).Data = []; % Preallocate results structure.

    disp(['Scheduling ' num2str(NrOfRuns) ' simulations...']);
    disp('-------------------------');

    for i = 1:NrOfRuns
        disp(['Run: ' num2str(i) '/' num2str(NrOfRuns)]);
    
        RunName = ['Run_' num2str(i, '%03i')];
        RunModel = [RunName '_cs'];
        ResultDir = [ResultsDir '\' RunName];

        % Create the complete command
        Settings = cellstr('Altered Settings:');
        Command = ExeName;
        % Command = ExperimentName;
        Command = [Command ' -load ' '"' MainExperiment '"'];
        Command = [Command ' -save ' '"' ResultDir '"'];    
        for j=1:size(Run(i).Settings,1)
            tag = Run(i).Settings{j,1};
            val = num2str(Run(i).Settings{j,2}, '%50.50g');
            Command = [Command ' -set ' tag '=' val];
            Settings(end+1) = cellstr([tag ' = ' val]);
        end
        
        Command = [Command ' -build'];    
        Command = [Command ' -close'];
    
        % Execute the command (creates altered PreScan experiment).
        errorCode = dos(Command);
        if errorCode ~= 0
            disp(['Failed to perform command: ' Command]);
            continue;
        end

        % Navigate to new experiment.
        cd(ResultDir);
        open_system(RunModel);
    
        % Regenerate compilation sheet.
        regenButtonHandle = find_system(RunModel, 'FindAll', 'on', 'type', 'annotation','text','Regenerate');
        regenButtonCallbackText = get_param(regenButtonHandle,'ClickFcn');
        eval(regenButtonCallbackText);
    
        % Determine simulation start and end times (avoid infinite durations).
        activeConfig = getActiveConfigSet(RunModel);
        startTime = str2double(get_param(activeConfig, 'StartTime'));
        endTime = str2double(get_param(activeConfig, 'StopTime'));
    
        % Simulate the new model.
        sim(RunModel, [startTime endTime]);

    
        % Store current settings to file.
        fileID = fopen([ResultDir '\settings.txt'],'wt');
        for line=1:length(Settings)
            fprintf(fileID, '%s\n',char(Settings(line)));
        end
        fclose(fileID);
    
        % Store results to file.
        ResultFileDir = [ResultDir '\Results\'];
        [mkDirStatus,mkDirMessage,mkDirMessageid] = mkdir(ResultFileDir);

        save_system(RunModel);
        close_system(RunModel);
        
    end

%% DATA output
filename = 'output_data.xls';                                              

% DSA OUTPUT 
Time = output_data.time(:,1);
ACCDist = output_data.signals.values(:,1);
...
XBRPriority = output_data.signals.values(:,24);


Results_Names={'Time', ...
               'ACCDist', ...
               ...
               'XBRPriority'};
Results_Values=[Time, ...
                ACCDist, ...
                ...
                XBRPriority];

sheet=1;
xlRange='A2';
xlswrite(filename,Results_Values,sheet,xlRange);

sheet=1;
xlRange='A1';
xlswrite(filename,Results_Names,sheet,xlRange);
    
% C-CAN 
Time = output_data.time(:,1);
ParkingBrake = output_data.signals.values(:,25);
...
TransSelectedGear = output_data.signals.values(:,57);


Results_Names={'Time', ...
               'ParkingBrake', ...
               ...
               'TransSelectedGear'};
           
Results_Values=[Time, ...
                ParkingBrake, ...
                ...
                TransSelectedGear];

sheet=2;
xlRange='A2';
xlswrite(filename,Results_Values,sheet,xlRange);

sheet=2;
xlRange='A1';
xlswrite(filename,Results_Names,sheet,xlRange);

% GENERAL INFO 
Time = output_data.time(:,1);
Day_Time_ = output_data.signals.values(:,58);
LaneValid = output_data.signals.values(:,59);
Mpo_ID = output_data.signals.values(:,60);
Road_Type = output_data.signals.values(:,61);
Sensor_State = output_data.signals.values(:,62);

Results_Names={'Time','Day_Time_','LaneValid','Mpo_ID','Road_Type','Sensor_State'};
Results_Values=[Time,Day_Time_,LaneValid,Mpo_ID,Road_Type,Sensor_State];


sheet=3;
xlRange='A2';
xlswrite(filename,Results_Values,sheet,xlRange);

sheet=3;
xlRange='A1';
xlswrite(filename,Results_Names,sheet,xlRange);

% TRACK_1 
Time = output_data.time(:,1);
Track1_A_Classi_1A = output_data.signals.values(:,63);
Track1_A_Conf = output_data.signals.values(:,64);
...
Track1_C_RelDiY = output_data.signals.values(:,75);

Results_Names={'Time', ...
               'Track1_A_Classi_1A', ...
               'Track1_A_Conf', ...
               ...
               'Track1_C_RelDiY'};
Results_Values=[Time, ...
                Track1_A_Classi_1A, ...
                Track1_A_Conf, ...
                ...
                Track1_C_RelDiY];

sheet=4;
xlRange='A2';
xlswrite(filename,Results_Values,sheet,xlRange);

sheet=4;
xlRange='A1';
xlswrite(filename,Results_Names,sheet,xlRange);

% TRACK_2 
Time = output_data.time(:,1);
Track2_A_Classi_2A = output_data.signals.values(:,76);
Track2_A_Conf = output_data.signals.values(:,77);
...
Track2_C_RelDiY = output_data.signals.values(:,88);

Results_Names={'Time', ...
               'Track2_A_Classi_2A', ...
               'Track2_A_Conf', ...
               ...
               'Track2_C_RelDiY'};
Results_Values=[Time, ...
                Track2_A_Classi_2A, ...
                Track2_A_Conf, ...
                ...
                Track2_C_RelDiY];

sheet=5;
xlRange='A2';
xlswrite(filename,Results_Values,sheet,xlRange);

sheet=5;
xlRange='A1';
xlswrite(filename,Results_Names,sheet,xlRange);

% TRACK_3 
Time = output_data.time(:,1);
Track3_A_Classi_3A = output_data.signals.values(:,89);
Track3_A_Confi = output_data.signals.values(:,90);
...
Track3_C_RelDiY = output_data.signals.values(:,101);

Results_Names={'Time', ...
               'Track3_A_Classi_3A', ...
               'Track3_A_Conf', ...
               ...
               'Track3_C_RelDiY'};
Results_Values=[Time, ...
                Track3_A_Classi_3A, ...
                Track3_A_Conf, ...
                ...
                Track3_C_RelDiY];

sheet=6;
xlRange='A2';
xlswrite(filename,Results_Values,sheet,xlRange);

sheet=6;
xlRange='A1';
xlswrite(filename,Results_Names,sheet,xlRange);

% Track 4 
Time = output_data.time(:,1);
Track4_A_Classi_4A = output_data.signals.values(:,102);
Track4_A_Conf = output_data.signals.values(:,103);
...
Track4_C_RelDiY = output_data.signals.values(:,114);

Results_Names={'Time', ...
               'Track4_A_Classi_4A', ...
               'Track4_A_Conf', ...
               ...
               'Track4_C_RelDiY'};
Results_Values=[Time, ...
                Track4_A_Classi_4A, ...
                Track4_A_Conf, ...
                ...
                Track4_C_RelDiY];

sheet=7;
xlRange='A2';
xlswrite(filename,Results_Values,sheet,xlRange);

sheet=7;
xlRange='A1';
xlswrite(filename,Results_Names,sheet,xlRange);

% Track 5 
Time = output_data.time(:,1);
Track5_A_Classi_5A = output_data.signals.values(:,115);
Track5_A_Conf = output_data.signals.values(:,116);
...
Track5_C_RelDiY = output_data.signals.values(:,127);

Results_Names={'Time', ...
               'Track5_A_Classi_5A', ...
               'Track5_A_Conf', ...
               ...
               'Track5_C_RelDiY'};
Results_Values=[Time, ...
                Track5_A_Classi_5A, ...
                Track5_A_Conf, ...
                ...
                Track5_C_RelDiY];

sheet=8;
xlRange='A2';
xlswrite(filename,Results_Values,sheet,xlRange);

sheet=8;
xlRange='A1';
xlswrite(filename,Results_Names,sheet,xlRange);

% Track 6 
Time = output_data.time(:,1);
Track6_A_Classi_6A = output_data.signals.values(:,128);
Track6_A_Conf = output_data.signals.values(:,129);
...
Track6_C_RelDiY = output_data.signals.values(:,140);

Results_Names={'Time', ...
               'Track6_A_Classi_6A', ...
               'Track6_A_Conf', ...
               ...
               'Track6_C_RelDiY'};
Results_Values=[Time, ...
                Track6_A_Classi_6A, ...
                Track6_A_Conf, ...
                ...
                Track6_C_RelDiY];

sheet=9;
xlRange='A2';
xlswrite(filename,Results_Values,sheet,xlRange);

sheet=9;
xlRange='A1';
xlswrite(filename,Results_Names,sheet,xlRange);
    
end

