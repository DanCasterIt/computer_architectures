I didn't modify folder's names with a more understandable ones because there would be the possibiliti that changing names will cause the projects to not work anymore.

-Problem_6_2017 corresponds to the folder: "lab02"
						item 1 is in file "esercizio1.s"
						item 2 is in file "esercizio2.s"
						item 3 is in file "esercizio3.s"
-Problem_7_2017 corresponds to the folder: "lab03_landtiger"

-Problem_8_2017  corresponds to the folder: "lab04"
						item 1 is in file "template.s"
						item 2 is in file "template2.s"
I want to apply for the FULL MODE: I implemented Problem_6_2017 with ALL the items in the file:
\full_mode\sample\startup_LPC17xx.s
my implementation starts from row 123. All items are separated in this way (in the same assembly file "startup_LPC17xx.s"):
;Problem_6_2017-3---------------------------------------------------------
	;AREA myCode, READONLY, CODE
	;ENTRY
	... code ...
;Problem_6_2017-2---------------------------------------------------------
	;AREA myCode, READONLY, CODE
	;ENTRY
	... code ...
;Problem_6_2017-1---------------------------------------------------------
	;AREA myCode, READONLY, CODE
	;ENTRY
	... code ...