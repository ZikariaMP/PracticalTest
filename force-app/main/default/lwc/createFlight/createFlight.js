import { LightningElement, track} from 'lwc';
import getAirportsDistance from '@salesforce/apex/CreateFlightController.getAirportsDistance';
import insertFlight from '@salesforce/apex/CreateFlightController.insertFlight';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateFlight extends LightningElement {
    departureAirportId = null;
    arrivalAirportId;
    airportsIds = [];
    @track airportsDistance=0;
    @track flightRecord;
    flightRecordId;
    flightInsertedBoolean = false;
    toastEvent;
    handleDepartureAirport(event){
        this.departureAirportId = event.target.value;
    }

    handleArrivalAirport(event){
        this.arrivalAirportId = event.target.value;
    }

    calculateDistance(){
        if (this.arrivalAirportId != null & this.departureAirportId != null){
            this.airportsIds.push(this.arrivalAirportId, this.departureAirportId);
            
            getAirportsDistance({ airportsIds : this.airportsIds})
            .then(result => {

                this.airportsDistance = result;
                if(this.airportsDistance != 0){

                    this.flightRecord = {
                        Departure_Airport__c : this.departureAirportId,
                        Arrival_Airport__c : this.arrivalAirportId,
                        Distance__c : this.airportsDistance
                    }

                    insertFlight({flight:this.flightRecord})
                    .then(result => {
                        console.log('FlightRecord: ', this.flightRecord);
                        this.flightRecord = {};
                        this.flightRecordId = result.Id;
                        this.flightInsertedBoolean = true;
                        this.toastEvent = new ShowToastEvent({
                            title:'Success!',
                            message:'Flight record is created Successfully!',
                            variant:'success'
                        });
                    })
                    .catch(error =>{
                        this.error = error.message;
                        console.log('ERROR: ', error.message);
                    });
                }else if(this.airportsDistance == 0){
                    this.toastEvent = new ShowToastEvent({
                        title:'Airport selected twice!',
                        message:'The distance between the Airports is 0KMs change the Arrival or Departure Airport',
                        variant:'error'
                    });
                }else{
                    this.toastEvent = new ShowToastEvent({
                        title:'Error with the Airport!',
                        message:'There is a problem with the selected Airports, select another Airport and try again',
                        variant:'error'
                    });
                }

                this.dispatchEvent(this.toastEvent);

              })
            .catch(error => {
                console.error('check error here', error);
            });
        }
       
    }
    
}