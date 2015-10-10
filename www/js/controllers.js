angular.module('ADIKB.controllers', [])

.controller('AboutKBCtrl', function($scope) {
	alert("test");
})

.controller('SettingsCtrl', function($scope) {

	$scope.push = null;
	$scope.txt = null;
    // Application Constructor
    initialize = function() {
        this.bindEvents();		
    },
		
    // Bind Event Listeners - Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents = function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);		 
    },

	// deviceready Event Handler
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'ADIKB.receivedEvent(...);'
    onDeviceReady = function() {
        bluemixpush();
    },
	
	alertNotification  = function(message) {
		console.log("Received notification");           
		alert(message);          
	}, 

	
    bluemixpush = function() {
        console.log("device is ready, let's initialize bluemix!");
		$scope.txt = "<font class='infoText'>Starting to register the device to ADI Knowledge Bite...</font><br/>";
        var values = {
           applicationId: "cc5dc093-0e59-4016-92eb-b9aefa575499",
		   applicationRoute: "http://ADIServices.mybluemix.net",
		   applicationSecret: "f4f20ea8a9931653cd71f74808c9781f36725f00"
        }; 
        IBMBluemix.initialize(values).then(function(){
			$scope.txt = $scope.txt + "<font class='infoText'>IBM Bluemix Initialized</font><br/>";	
			IBMPush.initializeService();
			$scope.txt = $scope.txt + "<font class='infoText'>IBM Push Initialized."+"</font><br/>";

		}).catch(function(err){
 			$scope.txt = $scope.txt + "<font class='errorText'> Error while initializing IBM Bluemix Push SDK -"+err  + "<br/>" + "Please make sure your device is online and retry" + "</font><br/>"+ "<br/>"	        		+ "<font class='infoText'>If issue persist, please contact Sunil Vashisth [suvashis@in.bm.com] or Ashis Panigrahi [ashisp@sg.ibm.com]</font>"+ "<br/>";
			IBMBluemix.getLogger().error("Error initializing the Push SDK or registering device: " + err); 
			
		});
		
    },
	
	$scope.register = function() {
		//ADIKB.initialize();
		$scope.push = IBMPush.getService();
		
		$scope.push.registerDevice(this.user.email,this.user.firstName,"alertNotification").done(function(response) {
			$scope.txt = $scope.txt +"Device successfully registered: "+ response;
		}, function(err) {
 			$scope.txt = $scope.txt +"<font class='errorText'> Error while registering device -"+err  + "<br/>" + "Please make sure your device is online and retry" + "</font><br/>"+ "<br/>"	        		+ "<font class='infoText'>If issue persist, please contact Sunil Vashisth [suvashis@in.bm.com] or Ashis Panigrahi [ashisp@sg.ibm.com]</font>"+ "<br/>";
			
		});
		
	}

	initialize();
    
})


.controller('HomeCtrl', function($scope) {
	

});
