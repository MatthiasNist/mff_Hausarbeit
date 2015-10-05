get and prepare data:-------------------------

getPrices hab ich etwas abgeaendert, da ja kein "tableContainer" mehr notwendig ist, weil nur ein Aktienkurs, der der DBK eingelesen wird.
Dementsprechend habe ich bestimmte Funktionen uebersprungen, sowie Schleifen und Iterierungsvariablen geloescht.

5.10.2015:

Die Daten waren anscheinend "falschrum" eingelesen und als Vektor/Table praepariert. Deshalb hab ich sie jetzt umgedreht, so ergeben
die Plots auch mehr Sinn in Bezug auf die Finanzkrise 2008. 

backtesting:----------------------------------

Als Mittelwert für den Garch-Prozess hab ich jetzt den "Constant"-Wert (k) aus dem Garch-objekt verwendet (Daten sind sinnvoll...) 
Alternativ gibt es auch einen "conditional mean model offset" (siehe auskommentierte Stelle) der sich nicht stark unterscheidet.

simulation:-----------------------------------

Wieso heisst es bei der vorletzten Aufgabe: "again (?), compare the empirical autocorrelation function of squared (?) 
returns for real world data with the counterpart of the default model."...?

simulierte Daten unterscheiden sich ziemlich stark...?

