CC = arm-hisiv100nptl-linux-gcc
#CC = gcc
OBJS = main.o projectinc.o
TARGET = ctrPro_daemon

$(TARGET): $(OBJS)
	$(CC) -lm -o $@ $^
          
%.o:%.c
	@echo "Compiling $< ..."
	$(CC) -c $<
        
clean:
	rm $(OBJS) $(TARGET) 
