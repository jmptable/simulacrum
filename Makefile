NAME := SUPERWATCH

SRCDIR := src
OBJDIR := obj
BINDIR := bin

HEX := $(BINDIR)\$(NAME).hex
OUT := $(OBJDIR)\$(NAME).out
MAP := $(OBJDIR)\$(NAME).map

SOURCES =	main.c \
			MakoVM.c \
			24LC256.c \
			Analog.c \
			Nokia3310.c \
			Serial.c \
			twimaster.c \
			
#HEADERS := src/inc/$(wildcard *.h)
INCLUDES = -Isrc/inc -Ires
OBJECTS = $(patsubst %,$(OBJDIR)\\%,$(SOURCES:.c=.o))
MCU := atmega328p
MCU_AVRDUDE := atmega328p
MCU_FREQ := 1000000UL

CC := avr-gcc
OBJCOPY := avr-objcopy
SIZE := avr-size -A

CFLAGS := -Wall -pedantic -mmcu=$(MCU) -std=c99 -g -Os -DF_CPU=$(MCU_FREQ) -gstabs

all: $(HEX)

clean:
	del $(HEX) $(OUT) $(MAP) $(OBJECTS)

flash: $(HEX)
	avrdude -y -c usbtiny -p $(MCU_AVRDUDE) -U flash:w:$(HEX)

$(HEX): $(OUT)
	$(OBJCOPY) -R .eeprom -O ihex $< $@

$(OUT): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ -Wl,-Map,$(MAP) $^
	@echo = = = = = = = = =
	$(SIZE) $@

$(OBJDIR)\\%.o: $(SRCDIR)\%.c
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<
	
$(OBJDIR):
	mkdir $(OBJDIR)

.PHONY: all clean flash

