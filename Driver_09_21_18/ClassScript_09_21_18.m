system = computer();
if strcmp(system, 'MACI64')
    serialPort = '/dev/cu.usbmodem1421';
else
    serialPort = 'COM5';
end


a = ExperimentClass_09_21_18(serialPort);

% a.linearOscillate(10,10,60,25,30,2,100);
% 
a.moveTo(30,30,500);
% 
% a.calibrate();
% 
%a.smoothPursuit(54000,60,-60,20,1000);
% 
% a.calibrate();

% a.moveTo(10,5,100); % x cm, y cm, hold ms

a.endSerial();