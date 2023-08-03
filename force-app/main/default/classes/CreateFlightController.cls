public with sharing class CreateFlightController {
    public CreateFlightController() {
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getAirportsDistance(List<id> airportsIds) {
        Decimal distanceInKM = 0;

        List<Account> airports = [SELECT Id, Name, Location__latitude__s, Location__longitude__s  FROM Account WHERE Id in :airportsIds];
        
        if (airports.size() > 1){
            distanceInKM = (calculateDistance(airports[0].Location__latitude__s,airports[0].Location__longitude__s,airports[1].Location__latitude__s,airports[1].Location__longitude__s)/1000).setscale(2,RoundingMode.DOWN);
        }
        return distanceInKM;
    }

    //Method to insert the flight record
    @AuraEnabled
    public static Case insertFlight(Case flight){
        try {
            insert flight;
            return flight;
        } catch (Exception e) {
            System.debug('ERROR: '+ e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Decimal calculateDistance(Decimal latitude1, Decimal longitude1,
        Decimal latitude2, Decimal longitude2) {
        Integer earthRadius = 6371 * 1000; // in meters
        // Transform coordinates from degrees to radians
        Decimal latitudeRadians1 = latitude1 * Math.PI/180;
        Decimal latitudeRadians2 = latitude2 * Math.PI/180;
        // Latitude and longitude differences in radians
        Decimal latitudeDelta = (latitude2 - latitude1) * Math.PI/180;
        Decimal longitudeDelta = (longitude2 - longitude1) * Math.PI/180;
        Decimal a = Math.sin(latitudeDelta/2) * Math.sin(latitudeDelta/2) +
        Math.cos(latitudeRadians1) * Math.cos(latitudeRadians2) *
        Math.sin(longitudeDelta/2) * Math.sin(longitudeDelta/2);
        Decimal arc = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Decimal distance = earthRadius * arc; // in metres
    return distance;
    }
    
}