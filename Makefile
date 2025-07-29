all: tictac

tictac: tictac.bas
	decbpp < tictac.bas > /tmp/tictac.bas
	sed -i 's/STEP/ STEP/g' /tmp/tictac.bas
ifneq ("$(wildcard /media/share1/COCO/drive3.dsk)", "")
	decb copy -tr /tmp/tictac.bas /media/share1/COCO/drive3.dsk,TICTAC.BAS
endif
	cat /tmp/tictac.bas
	#rm -f /tmp/tictac.bas
