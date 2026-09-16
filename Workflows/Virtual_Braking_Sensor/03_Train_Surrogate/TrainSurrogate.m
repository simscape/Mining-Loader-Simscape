function [bagModel, gpModel] = TrainSurrogate(FullResultsTable,now_string)
% Get index values for the validation and training tests

numAllTests = height(FullResultsTable);
numValidationTests = ceil(0.2*numAllTests);

allIdx = (1:numAllTests)';

validationTestsIdx = sort(randperm(numAllTests,numValidationTests))';
trainingTestsIdx = setdiff(allIdx,validationTestsIdx);


% Create Training and Validation Datasets
TrainingTable = FullResultsTable(trainingTestsIdx,:);
ValidationTable = FullResultsTable(validationTestsIdx,:);

figure
ahH(1) = subplot(121);
histogram(ahH(1),TrainingTable.BrakingDist,20)
title(ahH(1),'Braking Distance (Training)')
ylabel('Number of Tests');
xlabel('Distance (m)')
ahH(2) = subplot(122);
histogram(ahH(2),ValidationTable.BrakingDist,20)
title(ahH(2),'Braking Distance (Test)')
xlabel('Distance (m)')

linkaxes(ahH(:),'y');
set(gcf,'Position',[69   689   721   304])


% Single Output Models, Ensemble Trees
template = templateTree('MinLeafSize', 16, 'NumVariablesToSample', 'all', 'Surrogate','on');
bagModel = fitrensemble(TrainingTable(:,1:end-1),TrainingTable(:,end),'Method', 'Bag','NumLearningCycles', 100, 'Learners', template, ResponseName="BrakingDist"); 
% Accuracy of Gaussian Process Learners for Regression
[bagModelAcc, bagModelRSqr] = SurrogateModelValidation(...
    "BrakingDist",bagModel,'Regression Bagged Ensemble',ValidationTable);
set(gcf,'Position',[54   255   850   706])

if(~strcmp(now_string,'none'))
    saveas(gcf, ['Test_' now_string '_AccuracyRegression.png'])
end

% Single Output Models, Gaussian Process Regression
gpModel = fitrgp(TrainingTable(:,1:end-1),TrainingTable(:,end),'BasisFunction','constant','KernelFunction','rationalquadratic','Standardize', true, ResponseName="BrakingDist");
% Accuracy of Gaussian Process Learners for Regression
[gpModelAcc, gpModelRSqr] = SurrogateModelValidation(...
    "BrakingDist",gpModel,'Gaussian Process Regression',ValidationTable);
set(gcf,'Position',[54   255   850   706])

if(~strcmp(now_string,'none'))
    saveas(gcf, ['Test_' now_string '_GaussianProcess.png'])
end









