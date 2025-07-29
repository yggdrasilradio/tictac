all: tictac

tictac: tictac.bas
	decbpp < tictac.bas > redistribute/tictac.bas
	sed -i 's/STEP/ STEP/g' redistribute/tictac.bas
ifneq ("$(wildcard /media/share1/COCO/drive3.dsk)", "")
	decb copy -tr redistribute/tictac.bas /media/share1/COCO/drive3.dsk,TICTAC.BAS
endif
	cat redistribute/tictac.bas
