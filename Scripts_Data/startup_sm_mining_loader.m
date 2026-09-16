testConditions

IDatabase = sm_mining_loader_define_init;
Init = IDatabase.Flat;

sm_car_gen_driver_database
Driver = DDatabase.Grading.Mining_Loader;

sm_mining_loader_scenes
sm_mining_loader_load_cycle_A

MiningMachineParams

% If running in a parallel pool
% do not open model or demo script
open_start_content = 1;
if(~isempty(ver('parallel')))
    if(~isempty(getCurrentTask()))
        open_start_content = 0;
    end
end

if(open_start_content)
    %% If this is the top level project, open HTML script
    % Do not open it if this is a referenced project.
    this_project = simulinkproject;
    if(this_project.Information.TopLevel == 1)
        web('Mining_Loader_Design_Overview.html');
    end
end