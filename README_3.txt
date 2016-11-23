Ich hab jetzt zwei getPrices-Funktionen: Eine die nur einen Table einliest (f�r die DBK-Daten) mit Namen "getPrices" und eine die einen ganzen cell_array an Tablen einlesen kann mit Namen "getPrices_multi".

f�r getPrices_multi braucht es noch folgende, zusaetzliche Funktionen: 

- joinStockPriceSeries

- joinMultipleTables

Anmerkung: "discrete percentage return" ist jetzt letztlich als prozentuale Ver�nderung von Jahr zu Jahr implementiert (Definition Rendite, siehe "diskrete rendite": https://de.wikipedia.org/wiki/Rendite) 