classdef SerialConnect < handle

    properties
        connection
        forward_coeffs = zeros(4,4);
        reverse_coeffs = zeros(4,4);
        save_filename = 'parameters.mat';
    end
    
    methods
        %% Experiment Constructor
        function obj = SerialConnect(comPort)
            % Intializes Experiment class and opens connection
            obj.connection = serial(comPort);
            set(obj.connection,'DataBits',8);
            set(obj.connection,'StopBits',1);
            set(obj.connection,'BaudRate',14400);
            set(obj.connection,'Parity','none');
            
            fopen(obj.connection);
            
            % Confirms serial connection
            SerialInit = 'X';
            while (SerialInit~='A')
                SerialInit=fread(obj.connection,1,'uchar'); %be ready to receive any incoming data
            end
            if (SerialInit ~= 'A')
                disp('Serial Communication Not Setup');
            elseif (SerialInit=='A')
                disp('Serial Read')
            end
            
            fprintf(obj.connection,'%c','A'); %MATLAB sending 'A'
      
            %equivalent of typing 'A' into Serial monitor
%             mbox = msgbox('Serial Communication setup'); uiwait(mbox);
            flushinput(obj.connection);
            
            % Save parameters (forward_coeffs, reverse_coeffs) that will be sent from MATLAB
%             % to Arduino at start of each experiment
            parameters = load(obj.save_filename)
            
            obj.forward_coeffs = parameters.forward_coeffs;
            obj.reverse_coeffs = parameters.reverse_coeffs;
            forward_coeffs = obj.forward_coeffs;
            reverse_coeffs = obj.reverse_coeffs;
             
            waitSignal = check(obj); %should receive "ReadyToReceiveCoeffs"
            %sendCoeffs(obj, forward_coeffs);
            %waitSignal = check(obj); %should receive "ForwardCoeffsReceived"
            % waitSignal = check(obj) %should receive forward_coeffs
            sendCoeffs(obj, reverse_coeffs);
            waitSignal = check(obj) %should receive "ReverseCoeffsReceived"
            % waitSignal = check(obj) %should receive reverse_coeffs
            waitSignal = check(obj) %fscanf(obj.connection,'%s') %read from Arduino; should receive "Ready"
        end
        
        function output = readSerial(obj,type) 
            output = fscanf(obj.connection,type);
        end
        
        %% sendCoeffs function
        % takes in matrix of coeffcients
        % converts matrix to a string that with : delimiter
        % sends string to Arduino
        % receives string back from Arduino confirming coefficients 
        % were received and parsed
        
        function sendCoeffs(obj, coeffs)
            str = inputname(2);
            strList = sprintf(':%d', coeffs);
            strToSend = [str strList];
            fprintf(obj.connection, strToSend);      
        end
        
        %% waitSignal function
        function waitSignal = check(obj)
            data = '';
            while(1)
                data = fscanf(obj.connection, '%s');
                if isempty(data) == 1
                    data = fscanf(obj.connection, '%s');
                    %1
                elseif isempty(data) == 0
                    disp(data);
                    waitSignal = data;
                    %2
                    break;
                end
            end
        end

        %% checkForMovementEnd function
        function checkForMovementEnd(obj, message)
            endSignal = '';
            while(1)
                endSignal = fscanf(obj.connection, '%s');
                if strcmp(endSignal, 'Done') ~= 1
                else 
                    disp(message);
                    break;
                end
            end
        end
        
        %% Close Connection
        function endSerial(obj)
            fclose(obj.connection);
        end
               
    end
    
end