Objects:
Account gets transformed into Airports: Using the "Rename Tabs and Labels" rename the Account to Airport, for the IATA code I renamed the "Account Name" to "IATA Code" and on the field created a Validation that only allows to have 3CHAR lenght of the field. For longitude and Latitude fields rename the "Billing Latitude" to "Latitude" and lastly "Billing Longitude" to "Longitude".

The Case object gets transformed into the Flight object.
	
To relate the corresponding departure and arrival airport we will create two custom lookup fields related to Account (Airport) required. Lastly, for the flight distance, we will create a custom object of decimal type.

Conditions:
All the airports have to be created or edited at least once since the Location that contains the longitude and latitude is a required field that has to be filled.
Flights are created and it information shows only on successful insertions of the record.
