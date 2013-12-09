
///////////////////////////////////////////////////
///  Author: Emerson Rascoe
///  Communication Component
///  Manager Class
////////////////////////////////////////////////////

package com.communication
{
	import com.adobe.serialization.json.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.getTimer;
	
	import hessian.client.*;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;


	
	public class Communicator extends EventDispatcher implements mx.rpc.IResponder
	{
		private var _manager:Manager;
		private var _parent:MiddleMan;
		private var _loader:URLLoader;
		
		public function Communicator(inParent:MiddleMan)
		{
			this._parent = inParent;
			this._manager = this._parent.theManager;
		}
		
		
		/**
		 * Handles the communication request object and calls necessary method 
		 * depending on the object type 
		 * @param inObject
		 * 
		 */		
		public function sendRequest(inObject:Object):void
		{
			var objectType:String =  inObject.type;
			switch (objectType) 
			{
				case "HESSIAN":
					this.hessianRequest(inObject);
					break;
				case "AUTHENTICATE":
					this.authenticate(inObject);
					break;
				case "URL_REQUEST":
					this.handleURLRequest(inObject);
					break;
				default:
				    null
			}	
		}
		
		
		
		/**
		 *Creates a Hessian service and calls a method on it  
		 * @param inObject
		 * 
		 */		
		private function hessianRequest(inObject:Object):void
		{
			var serviceString:String = String(inObject.service);
			var serviceMethod:String = String(inObject.serviceMethod);
			var aService:HessianService = new HessianService(serviceString + "?R=" + Math.random() + "&T" + getTimer());

		    var communicatorToken1:AsyncToken;
		    var callFunction:Function = aService.getOperation(serviceMethod).send;
			communicatorToken1 = callFunction.apply(this,inObject.argumentList);
			inObject._token = communicatorToken1;
		    communicatorToken1.addResponder(this);
		}
		
		
		/**
		 * Public function that calls private jsonRequest function that does the work 
		 * @param inObject
		 * 
		 */		
		public function loginRequest(inObject:Object):void
		{
			//Logic can go here to make sure that the login menu is displayed
			//in order to use this method
			this.jsonRequest(inObject);
		}

		
		/**
		 *Taes all the communication request that remain in the queue and sends them after the 
		 * the user has logged back in 
		 * @param inArray
		 * 
		 */		
		private function sendStoredCommunicationRequests(inArray:Array):void
		{ 
			for(var i:int = 0; i< inArray.length;i++)
	    	{
	    		this.sendRequest(inArray[i]);
	    	}
		} 
		
		
		/**
		 * Handles simple verification requests 
		 * @param inObject
		 * 
		 */		
		private function authenticate(inObject:Object):void
		{
			var nullObject:Object = new Object();
			this._manager.removeRequestObject(inObject, nullObject );
		}
		
		/**
		 *Handles all URL requests to either navigate to a page or change the current page
		 *  
		 * @param inObject
		 * 
		 */		
		private function handleURLRequest(inObject:Object):void
		{
			var requestThumb:URLRequest = new URLRequest(inObject.service);
			navigateToURL(requestThumb,"_self");
		}
		
		
	
	/**
	 * Handles the Result of a Hessian Request
	 * The result recieves and Object which is a ResultEvent 
	 * @param data
	 * 
	 */		
	public function result(inData:Object):void
    {
         var rEvent:ResultEvent = ResultEvent(inData);
       	this._manager.removeRequestObject(this._manager.findRequestObjectByToken(rEvent.token), rEvent);
       	
     }     


      /**
       *Handles the errors from hessian, especially when data supplied 
       * to a hessian method is incorrect 
       * @param info
       * 
       */		
      public function fault(info:Object):void
      {
		    this._parent.theBroker.showError("Communicate_FLASH_ERROR");
			trace("A Fault Error occured with the Hessian Request");
      }

	}
}