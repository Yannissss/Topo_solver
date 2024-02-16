CC     = ifx
CFLAGS = -O3 -march=native

EXEC   = target
OBJS   = lecture_mol2.o chargeur_covalence.o main.o

all: $(EXEC)

run: $(EXEC)
	-@./$(EXEC) CoV_radii

$(EXEC): $(OBJS)
	-@echo ""
	-@echo "Linking    $(@)"
	-@echo ""
	-@$(CC) -o $@ $+

%.o: %.f90
	-@echo ""
	-@echo "Generating $@"
	-@$(CC) -c $<


###------------------------------
### Cleaning
###------------------------------------------------------------

clean:
	-@rm -rf *.o
	-@rm -rf *.mod
	-@rm -rf $(EXEC)

clean_all: clean cleanSource
	-@rm -rf $(EXEC)

cleanSource:
	-@find . \( -name "*~" -o -name "*.old" -o -name "#*" \) -print -exec rm \{\} \;


.PHONY:  $(EXEC) clean clean_all cleanSource
