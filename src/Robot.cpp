#include <iostream>
#include <memory>
#include <string>

#include <WPILib.h>
#include <AnalogInput.h>
#include <Joystick.h>
#include <SampleRobot.h>
#include <RobotDrive.h>
#include <Timer.h>
#include <CanTalonSRX.h>

class Robot: public frc::SampleRobot {
	frc::AnalogInput * lightsensor = new frc::AnalogInput(3);

public:
	Robot() {
		//myRobot.SetExpiration(0.1);
	}

	void RobotInit() {
		std::cout << "Robot enabled!" << std::endl;
	}

	void Autonomous() {

	}

	void OperatorControl() override {
		//myRobot.SetSafetyEnabled(true);
		while (IsOperatorControl() && IsEnabled()) {
			std::cout << lightsensor->GetValue() << std::endl;
			frc::Wait(0.005);
		}
	}

	void Test() override {
		while(IsEnabled()) {
			std::cout << lightsensor->GetValue() << std::endl;
			frc::Wait(0.005);
		}
	}
};

START_ROBOT_CLASS(Robot)
