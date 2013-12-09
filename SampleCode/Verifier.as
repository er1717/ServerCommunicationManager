
///////////////////////////////////////////////////
///  Author: Emerson Rascoe
///  Communication Component
///  Verifier Class
////////////////////////////////////////////////////

package com.communication
{
	
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import hessian.client.*;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import com.adobe.images.JPGEncoder;
	
	public class Verifier extends EventDispatcher implements mx.rpc.IResponder
	{
	    private var _parent:MiddleMan;
	   	private var _manager:Manager;
	    private var _communicator:Communicator;
	    private var _service:HessianService;
		private var _tempObject:Object;
				
				
		public function Verifier(inParent:MiddleMan)
		{
			this._parent = inParent;
			this.init();
		}
		
		/**
		 * Calls sets up all necessary class member for this class to function 
		 * 
		 */		
		private function init():void
		{
	   		this._manager  = this._parent.theManager;
	   		this._communicator = this._parent.theCommunicator;
		}
		
		
		/**
		 * Public function the MiddleMan main class will call to pass its 
		 * communication request object it recieved from the Broker
		 * This is Where logic test for necessary conditions should be made 
		 * @param inObject
		 * 
		 */		
		public function verify(inObject:Object):void
		{

			if( inObject.id && inObject.id is Number) 
      		{
				this.sendToVerifyService(inObject);
      		}
      		else
      		{
      			//Can add more logic to this if necessary Emerson
      			this._parent.theBroker.showError("Not a valid user");  
      		}
		}
		
		
		    
///////////////////////////////////  HESSIAN CODE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      /**
       * Recieves the communication request object from the Broker and proceeds with the verification 
       * process only if the user id inside the object exist and is of type number
       * @param inObject
       * 
       */
      private function sendToVerifyService(inObject:Object):void
      {  
	       this._manager.registerCommunicationRequestObjects(inObject);
	       var tip:String = this._parent._broker.remoteAuthenticationAdress + "?R=" + Math.random() + "&T" + getTimer();
	       this._service = new HessianService(this._parent._broker.remoteAuthenticationAdress + "?R=" + Math.random() + "&T" + getTimer());
	       var aToken:AsyncToken =  _service.getOperation("verifyAuthentication").send(inObject.id);
	       aToken.addResponder(this);
	       inObject._token = aToken;
      }
 

      /**
       * Recieves a Result Event Object back from the server alng with a response
       * and a token that can be compared against stored object token properties 
       * to compare communication request objects
       * @param data
       * 
       */
      public function result(data:Object):void
      {
      	   var event:ResultEvent = ResultEvent(data);
	       var inString:String = String(event.result); 
                switch (inString) 
				{
					case "AUTHENTICATED":
						this._communicator.sendRequest(this._manager.findRequestObjectByToken(event.token));
						break;
					case "REQUIRES_LOGIN":
					     this._parent.theBroker.showLoginMenu();
						break;
					case "ERROR":
						this._parent.theBroker.showError("Verify_" + inString);
						break;
					case "INTERNAL_ERROR":
					     this._parent.theBroker.showError("Verify_" + inString);
						break;
					default:
					    null
				}
      }     


      /**
       * Undefined for the moment until further info is obtained on the types of erros
       * we will be handling 
       * @param info
       * 
       */
      public function fault(info:Object):void
      {
      	//Can handle non return errors
      	this._parent.theBroker.showError("Verify_FLASH_ERROR");     
      }
///////////////////////////////////  END OF HESIAN CODE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      

	}
}