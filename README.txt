PART 1: ======================================

get and prepare data:-------------------------

getPrices hab ich etwas abgeaendert, da ja kein "tableContainer" mehr notwendig ist, weil nur ein Aktienkurs, der der DBK eingelesen wird.
Dementsprechend habe ich bestimmte Funktionen uebersprungen, sowie Schleifen und Iterierungsvariablen geloescht.

5.10.2015:

Die Daten waren anscheinend "falschrum" eingelesen und als Vektor/Table praepariert. Deshalb hab ich sie jetzt umgedreht, so ergeben
die Plots auch mehr Sinn in Bezug auf die Finanzkrise 2008. 

backtesting:----------------------------------

Als Mittelwert f�r den Garch-Prozess hab ich jetzt den "Constant"-Wert (k) aus dem Garch-objekt verwendet (Daten sind sinnvoll...) 
Alternativ gibt es auch einen "conditional mean model offset" (siehe auskommentierte Stelle) der sich nicht stark unterscheidet.

simulation:-----------------------------------

Wieso heisst es bei der vorletzten Aufgabe: "again (?), compare the empirical autocorrelation function of squared (?) 
returns for real world data with the counterpart of the default model."...?

simulierte Daten unterscheiden sich ziemlich stark...?


PART 2: ======================================

Ich hab jetzt zwei getPrices-Funktionen: Eine die nur einen Table einliest (f�r die DBK-Daten) mit Namen "getPrices" und eine die einen ganzen cell_array an Tablen einlesen kann mit Namen "getPrices_multi".

f�r getPrices_multi braucht es noch folgende, zusaetzliche Funktionen: 

- joinStockPriceSeries

- joinMultipleTables

Anmerkung: "discrete percentage return" ist jetzt letztlich als prozentuale Ver�nderung von Jahr zu Jahr implementiert (Definition Rendite, siehe "diskrete rendite": https://de.wikipedia.org/wiki/Rendite). 

F�r diese implementierung habe ich die urspr�ngliche Funktion "price2retWithHolidays" in "price2disc_retWithHolidays" abge�ndert, die jetzt eine Matrix (sinnvoller f�r weitere Verwenung als ein table) mit den diskreten Renditen in Prozent ausgibt.



