#ifndef	__COMMAND_H__
#define	__COMMAND_H__

#include <iostream>

using namespace	std;

class Receiver
{
	public:
		void action() { cout << "Receiver: To do!!!!!" << endl; };
};

class Command
{
	public:
		virtual void excute() = 0;
};

class ConcreteCommand : public Command
{
	public:
		void setReceiver( Receiver * pReceiver )
		{
			m_pReceiver = pReceiver;
		}
		void excute()
		{
			m_pReceiver->action();
		}
	private:
		Receiver	* m_pReceiver;
};

class Invoker
{
	public:
		void setCommand( Command * pCommand )
		{
			m_pCommand = pCommand;
		}
		void excute()
		{
			m_pCommand->excute();
		}
	private:
		Command	* m_pCommand;
};
#endif	//	__COMMAND_H__
