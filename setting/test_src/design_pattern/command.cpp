
#include "command.h"

int main()
{
	Invoker		invoker;
	Receiver	receiver;
	ConcreteCommand		command;

	command.setReceiver( & receiver );

	invoker.setCommand( & command );
	invoker.excute();

	return 0;
}
