@isTest
public with sharing class CreateFlightControllerTest {
    
    @testSetup static void setUpMethod() {
        Account airport1 = new Account(Name = 'BCN', Location__latitude__s = 1, Location__longitude__s = 1);
        Account airport2 = new Account(Name = 'MDR', Location__latitude__s = 2, Location__longitude__s = 2);
        insert new List<Account>{airport1, airport2};
    }

    @isTest 
    public static void calculateDistanceSuccessfully(){

        List<Account> airports = [SELECT id FROM Account];

        List<Id> airportIds = new List<Id>();

        for (Account airport : airports) {
            airportIds.add(airport.Id);
        }
        Test.startTest();
        Decimal distance = CreateFlightController.getAirportsDistance(airportIds);
        Test.stopTest();
        System.assertEquals(157.22, distance); 
    }

    @isTest 
    public static void calculateDistanceError(){
        List<Account> airports = [SELECT id FROM Account LIMIT 1];
        List<Id> airportIds = new List<Id>();

        for (Account airport : airports) {
            airportIds.add(airport.Id);
        }
        Test.startTest();
        Decimal distance = CreateFlightController.getAirportsDistance(airportIds);
        Test.stopTest();
        System.assertEquals(0, distance);
    }
    
	@isTest 
    public static void createFlight(){
		
        List<Account> airports = [SELECT id FROM Account];
        List<Id> airportIds = new List<Id>();
		Case insertedFlight;
        
        for (Account airport : airports) {
            airportIds.add(airport.Id);
        }
        
        Decimal distance = CreateFlightController.getAirportsDistance(airportIds);
		Case flight = new Case ( Departure_Airport__c = airportIds[0], Arrival_Airport__c = airportIds[1], Distance__c = distance); 
       
        Test.startTest();
        insertedFlight = CreateFlightController.insertFlight(flight);
        Test.stopTest();
        
        System.assertEquals(flight, insertedFlight); 
    }
}