Ich hab jetzt zwei getPrices-Funktionen: Eine die nur einen Table einliest (für die DBK-Daten) mit Namen "getPrices" und eine die einen ganzen cell_array an Tablen einlesen kann mit Namen "getPrices_multi" => Am Ende beides "Parts" hochladen.

für getPrices_multi braucht es noch folgende, zusaetzliche Funktionen: 

- joinStockPriceSeries

- joinMultipleTables

Anmerkung: "discrete percentage return" als Bestandsgroessen und nicht Flussgroessen (also um die 100% jeweils)


Anmerkung vorletzte Teilaufgabe:

Bei der Simulation der vier weights (drei durch die funktion "unif_random") hat das vierte weights letztlich eine unterschiedliche Varianz, dagegen spricht aber keine der vorgegebenen constraints.