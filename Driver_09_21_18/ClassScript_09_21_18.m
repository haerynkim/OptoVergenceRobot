system = computer();
if strcmp(system, 'MACI64')
    serialPort = '/dev/tty.usbmodem1411';
else
    serialPort = 'COM5';
end
a = ExperimentClass_09_21_18(serialPort);

% a.linearOscillate(10,10,60,25,30,2,100);
% 
% a.moveTo(15,15,500);
% 
% a.calibrate();
% 
a.smoothPursuit(2000,60,-60,15,1000);
% 
%a.calibrate();

%a.moveTo(10,5,100); % x cm, y cm, hold ms

a.endSerial();