
function [accuracy, rSquared] = SurrogateModelValidation(perfMetricName,regressionModel,regMdlName,testTable)
%% Surrogate Model Validation

responseName = perfMetricName;
myPredictFcn = @(predictors) predict(regressionModel, predictors);

% Compute predictions on the test dataset
responseValue = testTable.(responseName);
responsePred = myPredictFcn(testTable);

% Compute root-mean-squared error and R-squared to show model accuracy
accuracy = rmse(responsePred,responseValue);
rSquared = 1.0 - accuracy.^2/var(responseValue);
%disp("Accuracy RMSE = " + accuracy + ", R-Squared = " + rSquared);

% Show scatter plot with 1:1 correlation line, and accuracy values in the title
figure;
plot(responseValue,responsePred,"ms");
xlabel("Value (Simscape model)");
ylabel("Prediction (AI Surrogate)");
title(['Accuracy of ' regMdlName ' for ' char(responseName)]); 
text(0.05,0.9,sprintf('Accuracy RMSE = %1.4f \nR-Squared          = %1.4f', accuracy,rSquared),'Units','Normalized');
refline(1.0,0.0);
%axis equal;
axis square;
grid on;
