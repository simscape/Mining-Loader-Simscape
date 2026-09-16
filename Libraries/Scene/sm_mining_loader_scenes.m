SceneData.Grid.len   = 260;
SceneData.Grid.wid   = 60;
SceneData.Grid.nsq_x = 26;
SceneData.Grid.nsq_y = 4;
SceneData.Grid.dep      = 0.08;
SceneData.Grid.line_wid = 0.1;
SceneData.Grid.line_clr = [1 1 1];
SceneData.Grid.line_opc = 1;
SceneData.Grid.surf_clr = [1 1 1];
SceneData.Grid.surf_opc = 1;

SceneData.bank.qBank = 10; % deg
SceneData.bank.xBank = 2;  % m
SceneData.bank.x_vec = [-0.5 0.5]*SceneData.Grid.len;
SceneData.bank.y_vec = [-0.5 0 0.5]*SceneData.Grid.wid+SceneData.bank.xBank;
SceneData.bank.z_mat = [0 0 1;0 0 1]*tand(SceneData.bank.qBank)*SceneData.Grid.wid/2;
SceneData.bank.clr   = [0.8588 0.7137 0.549];

SceneData.bank.Grid.len   = SceneData.Grid.len;
SceneData.bank.Grid.wid   = SceneData.Grid.wid/2;
SceneData.bank.Grid.nsq_x = 25;
SceneData.bank.Grid.nsq_y = 4/2;
SceneData.bank.Grid.dep      = 0.02;
SceneData.bank.Grid.line_wid = 0.02;
SceneData.bank.Grid.line_clr = [1 1 1];
SceneData.bank.Grid.line_opc = 1;
SceneData.bank.Grid.surf_clr = SceneData.bank.clr;
SceneData.bank.Grid.surf_opc = 1;
SceneData.bank.offset = [0 ...
    SceneData.bank.Grid.wid/2+SceneData.bank.xBank ...
    SceneData.bank.Grid.wid/2*tand(SceneData.bank.qBank)];

SceneData.park.len   = 20;
SceneData.park.wid   = 20;
SceneData.park.nsq_x = 2;
SceneData.park.nsq_y = 2;
SceneData.park.dep      = 0.02;
SceneData.park.line_wid = 0.02;
SceneData.park.line_clr = [1 1 1];
SceneData.park.line_opc = 1;
SceneData.park.surf_clr = [1 1 1];
SceneData.park.surf_opc = 1;
