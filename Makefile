CC     = ifx
CFLAGS = -O3 -march=native

EXEC   = complete_mol2
OBJS   = lecture_mol2.o chargeur_covalence.o affiche_topologie.o complete_mol2.o 

all: $(EXEC)

run: $(EXEC)
	-@./$(EXEC) CoV_radii 1QSN_NO_BOND.mol2 1QSN_SOLVED.mol2

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
